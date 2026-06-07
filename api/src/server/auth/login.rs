use crate::database;
use crate::server::error::ApiError;
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use axum::http;
use axum::http::HeaderValue;
use axum::response::IntoResponse;
use axum::response::Response;
use chrono::{DateTime, Utc};
use cookie::time::Duration;
use jsonwebtoken::DecodingKey;
use jsonwebtoken::EncodingKey;
use jsonwebtoken::Validation;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Deserialize)]
pub struct LoginInput {
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub password: String,
}

#[derive(Debug, Clone, Serialize)]
pub struct LoginReponse {
    pub access_token: String,
    pub refresh_token: String,
}

pub async fn login(
    State(state): State<AppState>,
    Json(payload): Json<LoginInput>,
) -> Result<Response, ApiError> {
    // normalize the email.
    let email = payload.email.to_lowercase();
    // fetch the account by email.
    let account = database::account::get(&state.pool, &email).await?;
    let account = match account {
        Some(account) => account,
        None => {
            return Err(ApiError::InvalidField {
                field: "email".into(),
                message: "invalid credentials".into(),
            });
        }
    };
    // Verify the password.
    // Note: return the same error as above so we can't know if
    // the account exists or if the password is invalid.
    if !account.verify_password(&payload.password).await {
        return Err(ApiError::InvalidField {
            field: "email".into(),
            message: "invalid credentials".into(),
        });
    }
    // create access_token
    let access_token = generate_access_token(&state.access_token_key, &account.id, Utc::now())?;
    // create refresh_token
    let refresh_token = database::token::generate(&state.pool, &account.id).await?;
    let mut response = Json(LoginReponse {
        access_token: access_token,
        refresh_token: refresh_token.clone(),
    })
    .into_response();
    // return the refresh token in a cookie
    let cookie = cookie::Cookie::build(("refresh_token", refresh_token))
        .max_age(Duration::days(30))
        .path("/")
        .secure(true)
        .http_only(true);
    let cookie = cookie
        .to_string()
        .parse::<HeaderValue>()
        .map_err(|_| ApiError::InternalError)?;
    response
        .headers_mut()
        .insert(http::header::SET_COOKIE, cookie);
    return Ok(response);
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct JwtClaim {
    pub sub: String,
    #[serde(with = "chrono::serde::ts_seconds")]
    pub exp: DateTime<Utc>,
    #[serde(with = "chrono::serde::ts_seconds")]
    pub iat: DateTime<Utc>,
}

pub fn generate_access_token(
    key: &[u8; 32],
    account_id: &str,
    iat: DateTime<Utc>,
) -> anyhow::Result<String> {
    let claims = JwtClaim {
        sub: account_id.into(),
        iat: iat.clone(),
        exp: iat,
    };
    let header = jsonwebtoken::Header::new(jsonwebtoken::Algorithm::HS256);
    let key = EncodingKey::from_secret(&key.to_vec());
    let token = jsonwebtoken::encode(&header, &claims, &key)?;
    Ok(token.to_string())
}

pub fn verify_access_token(
    key: &[u8; 32],
    token: &str,
    password_updated_at: DateTime<Utc>,
) -> Result<String, ApiError> {
    let key = DecodingKey::from_secret(&key.to_vec());
    let claims = jsonwebtoken::decode::<JwtClaim>(token, &key, &Validation::default())
        .map_err(|_| ApiError::InvalidTokenError)?;
    if password_updated_at > claims.claims.iat {
        return Err(ApiError::InvalidTokenError);
    }
    Ok(claims.claims.sub.clone())
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::database;
    use crate::server::testing;
    use chrono::Duration;

    #[tokio::test]
    async fn test_login_no_payload() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server.post("/api/login").json(&serde_json::json!({})).await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"error": {"email": "invalid credentials"}})
        );
    }

    #[tokio::test]
    async fn test_login_invalid_email() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        // create a test user
        database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        // use an invalid email
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "invalid@mail.com",
                "password": "123456789",
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"error": {"email": "invalid credentials"}})
        );
    }

    #[tokio::test]
    async fn test_login_invalid_password() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        // create a test user
        database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        // use an invalid password
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "123456789_invalid",
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"error": {"email": "invalid credentials"}})
        );
    }

    #[tokio::test]
    async fn test_login() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        // create a test user
        database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();

        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "123456789",
            }))
            .await;
        response.assert_status_ok();
        let body = response.json::<serde_json::Value>();
        assert!(body.get("access_token").is_some());
        assert!(body.get("refresh_token").is_some());
        // try again with an upper case email and with spaces
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "   TEST@mail.com    ",
                "password": "123456789",
            }))
            .await;
        response.assert_status_ok();
        // check response
        let body = response.json::<serde_json::Value>();
        assert!(body.get("access_token").is_some());
        assert!(body.get("refresh_token").is_some());
        // check cookie
        let cookie = response.maybe_header(http::header::SET_COOKIE).unwrap();
        let cookie_str = std::string::String::from_utf8_lossy(cookie.as_bytes());
        let cookie = cookie::Cookie::parse(cookie_str.clone()).unwrap();
        assert_eq!("refresh_token", cookie.name());
        // check the refresh_token are the same in the response
        // and the cookie
        assert_eq!(
            body.get("refresh_token").unwrap().as_str().unwrap(),
            cookie.value()
        );
    }

    #[tokio::test]
    async fn test_access_token() {
        let (_, pool) = testing::init_test_server().await;
        // create a test user
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let access_token = generate_access_token(&key, &account.id, Utc::now()).unwrap();
        assert_eq!(
            account.id,
            verify_access_token(&key, &access_token, account.password_updated_at).unwrap()
        );
    }

    #[tokio::test]
    async fn test_access_token_expired() {
        let (_, pool) = testing::init_test_server().await;
        // create a test user
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let past_iat = Utc::now() - Duration::days(1);
        let access_token = generate_access_token(&key, &account.id, past_iat).unwrap();
        assert!(verify_access_token(&key, &access_token, account.password_updated_at,).is_err());
    }

    #[tokio::test]
    async fn test_access_token_password_change() {
        let (_, pool) = testing::init_test_server().await;
        // create a test user
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let access_token = generate_access_token(&key, &account.id, Utc::now()).unwrap();
        assert!(
            verify_access_token(
                &key,
                &access_token,
                account.password_updated_at + Duration::minutes(1)
            )
            .is_err()
        );
    }
}
