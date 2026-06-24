use crate::database;
use crate::server::error::ApiError;
use crate::server::error::FieldError;
use crate::server::extractor::JsonInput;
use crate::server::lib::cookies::RefreshTokenCookie;
use crate::server::lib::token;
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use axum::http;
use axum::response::IntoResponse;
use axum::response::Response;
use chrono::Utc;
use serde::{Deserialize, Serialize};
use serde_with::serde_as;

#[serde_as]
#[derive(Debug, Clone, Deserialize)]
pub struct LoginInput {
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub password: Vec<u8>,
}

impl LoginInput {
    fn validate(&mut self) -> Result<(), ApiError> {
        self.email = self.email.to_lowercase();
        let errors: Vec<FieldError> = vec![
            FieldError::check_email_invalid("email", &self.email),
            FieldError::check_required("password", &self.password),
        ]
        .into_iter()
        .flatten()
        .collect();
        if errors.is_empty() {
            return Ok(());
        }
        return Err(ApiError::BadRequestFieldErrors(errors));
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct LoginReponse {
    pub access_token: String,
    pub refresh_token: String,
}

pub async fn login(
    State(state): State<AppState>,
    JsonInput(mut payload): JsonInput<LoginInput>,
) -> Result<Response, ApiError> {
    payload.validate()?;

    // fetch the account by email.
    let account = database::account::get_by_email(&state.pool, &payload.email).await?;
    let account = match account {
        Some(account) => account,
        None => {
            return Err(ApiError::BadRequestFieldErrors(vec![
                FieldError::CredentialsInvalid("email".into()),
            ]));
        }
    };
    // Verify the password.
    // Note: return the same error as above so we can't know if
    // the account exists or if the password is invalid.
    if !account.verify_password(&payload.password).await {
        return Err(ApiError::BadRequestFieldErrors(vec![
            FieldError::CredentialsInvalid("email".into()),
        ]));
    }
    // create access_token
    let access_token = token::new(&state.access_token_key, &account.id, Utc::now())?;
    // create refresh_token
    let refresh_token = database::token::generate(&state.pool, &account.id).await?;
    let mut response = Json(LoginReponse {
        access_token: access_token,
        refresh_token: refresh_token.clone(),
    })
    .into_response();
    // return the refresh token in a cookie
    let cookie = RefreshTokenCookie::build(&refresh_token, !state.dev)?;
    response
        .headers_mut()
        .insert(http::header::SET_COOKIE, cookie.into());
    return Ok(response);
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::server::testing;

    #[tokio::test]
    async fn test_login_no_payload() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({"email": "", "password": ""}))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                FieldError::EmailInvalid("email".into()),
                FieldError::ValueRequired("password".into())
            ]}),
        );
    }

    #[tokio::test]
    async fn test_login_invalid_email() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let _ = testing::build_default_account(&state.pool).await;
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "invalid@mail.com",
                "password": "0".repeat(64),
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                FieldError::CredentialsInvalid("email".into())
            ]}),
        );
    }

    #[tokio::test]
    async fn test_login_invalid_password() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let _ = testing::build_default_account(&state.pool).await;
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                 "password": "1".repeat(64),
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                FieldError::CredentialsInvalid("email".into())
            ]}),
        );
    }

    #[tokio::test]
    async fn test_login() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let email = "test@mail.com";
        let password = "0".repeat(64);
        // test full integration
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": email,
                "password": password,
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_ok();
        let response = server
            .post("/api/login")
            .json(&serde_json::json!({
                "email": email,
                "password": password,
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
                "email": format!("    {email}    "),
                "password": password,
            }))
            .await;
        response.assert_status_ok();
        // check response
        let body = response.json::<serde_json::Value>();
        assert!(body.get("access_token").is_some());
        assert!(body.get("refresh_token").is_some());
        // check cookie
        let cookie = response.maybe_header(http::header::SET_COOKIE).unwrap();
        let cookie = RefreshTokenCookie::try_from(cookie).unwrap();
        // check the refresh_token are the same in the response
        // and the cookie
        assert_eq!(
            body.get("refresh_token").unwrap().as_str().unwrap(),
            cookie.token().unwrap()
        );
    }
}
