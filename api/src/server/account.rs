use super::error::ApiError;
use super::state::AppState;
use crate::database;
use axum::Json;
use axum::extract::State;
use serde::{Deserialize, Serialize};
use validator::ValidateEmail;

fn trimmed<'de, D: serde::Deserializer<'de>>(d: D) -> Result<String, D::Error> {
    use serde::Deserialize;
    Ok(String::deserialize(d)?.trim().to_string())
}

#[derive(Debug, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(default, deserialize_with = "trimmed")]
    pub email: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub password: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub password_repeat: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub c_id: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub c_code: String,
}

pub async fn register(
    State(state): State<AppState>,
    Json(mut payload): Json<RegisterInput>,
) -> Result<(), ApiError> {
    // normalize email and check if it's valid.
    payload.email = payload.email.to_lowercase();

    if !payload.email.validate_email() {
        return Err(ApiError::InvalidField {
            field: "email".into(),
            message: "invalid".into(),
        });
    }
    // check the password a min lenght.
    // note: no need to enforce a character set because
    if payload.password.len() < 8 {
        return Err(ApiError::InvalidField {
            field: "password".into(),
            message: "must be at least 8 char long".into(),
        });
    }
    // check the password has a minimum length
    if payload.password != payload.password_repeat {
        return Err(ApiError::InvalidField {
            field: "password".into(),
            message: "mismatch".into(),
        });
    }
    // check the captchat is valid
    let is_valid = database::captchat::verify(&state.pool, &payload.c_id, &payload.c_code).await?;
    if !is_valid {
        return Err(ApiError::InvalidField {
            field: "code".into(),
            message: "invalid".into(),
        });
    }
    // insert account into the database
    let res = database::account::insert(
        &state.pool,
        database::account::AccountInsert {
            email: payload.email.clone(),
            password: payload.password.clone(),
        },
    )
    .await;
    match res {
        Ok(_) => {}
        Err(e) => match e {
            sqlx::Error::Database(db_err)
                if db_err.kind() == sqlx::error::ErrorKind::UniqueViolation =>
            {
                tracing::error!("email {} already exists", payload.email);
                return Err(ApiError::InvalidField {
                    field: "email".into(),
                    message: "duplicated".into(),
                });
            }
            _ => {
                tracing::error!("database error: {e}");
                return Err(ApiError::InternalError);
            }
        },
    }
    println!("{:?}", payload);
    Ok(())
}

#[derive(Debug, Clone, Deserialize)]
pub struct LoginInput {
    #[serde(default, deserialize_with = "trimmed")]
    pub email: String,
    #[serde(default, deserialize_with = "trimmed")]
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
) -> Result<Json<LoginReponse>, ApiError> {
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
    // the account exist or if the password is invalid.
    if !account.verify_password(&payload.password).await {
        return Err(ApiError::InvalidField {
            field: "email".into(),
            message: "invalid credentials".into(),
        });
    }
    return Ok(Json(LoginReponse {
        access_token: "".into(),
        refresh_token: "".into(),
    }));
}

#[tokio::test]
async fn test_register_invalid_email() {
    let (app, _) = super::testing::init_test_server().await;
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "notanemail",
            "password": "password123",
            "password_repeat": "password123",
            "c_id": "",
            "c_code": ""
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"email": "invalid"}}));
}

#[tokio::test]
async fn test_register_short_password() {
    let (app, _) = super::testing::init_test_server().await;
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "1234",
            "password_repeat": "1234",
            "c_id": "",
            "c_code": ""
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(
        body,
        serde_json::json!({"error": {"password": "must be at least 8 char long"}})
    );
}

#[tokio::test]
async fn test_register_repeat_password() {
    let (app, _) = super::testing::init_test_server().await;
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "1234567890",
            "c_id": "",
            "c_code": ""
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"password": "mismatch"}}));
}

#[tokio::test]
async fn test_register_invalid_code() {
    let (app, pool) = super::testing::init_test_server().await;
    let (cap, code) = database::captchat::generate(&pool).await.unwrap();
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "123456789",
            "c_id": cap.id.clone(),
            "c_code": code+"invalid",
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"code": "invalid"}}));
}

#[tokio::test]
async fn test_register_invalid_c_id() {
    let (app, pool) = super::testing::init_test_server().await;
    let (_, code) = database::captchat::generate(&pool).await.unwrap();
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "123456789",
            "c_id": uuid::Uuid::now_v7().to_string(),
            "c_code": code,
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"code": "invalid"}}));
}

#[tokio::test]
async fn test_register_reuse_c_id() {
    let (app, pool) = super::testing::init_test_server().await;
    let (cap, code) = database::captchat::generate(&pool).await.unwrap();
    database::captchat::verify(&pool, &cap.id, &code)
        .await
        .unwrap();
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "123456789",
            "c_id": &cap.id,
            "c_code": code,
        }))
        .await;
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"code": "invalid"}}));
}

#[tokio::test]
async fn test_register_valid() {
    let (app, pool) = super::testing::init_test_server().await;
    let (cap, code) = database::captchat::generate(&pool).await.unwrap();
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "123456789",
            "c_id": &cap.id,
            "c_code": code,
        }))
        .await;
    response.assert_status_ok();
}

#[tokio::test]
async fn test_register_duplicated() {
    let (app, pool) = super::testing::init_test_server().await;
    // insert account
    database::account::insert(
        &pool,
        database::account::AccountInsert {
            email: "test@mail.com".into(),
            password: "123456789".into(),
        },
    )
    .await
    .unwrap();
    let (cap, code) = database::captchat::generate(&pool).await.unwrap();
    let server = axum_test::TestServer::new(app);
    let response = server
        .post("/api/register")
        .json(&serde_json::json!({
            "email": "test@mail.com",
            "password": "123456789",
            "password_repeat": "123456789",
            "c_id": &cap.id,
            "c_code": code,
        }))
        .await;
    response.assert_status_bad_request();
    let body = response.json::<serde_json::Value>();
    assert_eq!(body, serde_json::json!({"error": {"email": "duplicated"}}));
}

#[tokio::test]
async fn test_login_no_payload() {
    let (app, _) = super::testing::init_test_server().await;
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
    let (app, pool) = super::testing::init_test_server().await;
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
    let (app, pool) = super::testing::init_test_server().await;
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
    let (app, pool) = super::testing::init_test_server().await;
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
            "password": "123456789",
        }))
        .await;
    response.assert_status_ok();
    let body = response.json::<serde_json::Value>();
    assert_eq!(
        body,
        serde_json::json!({
            "access_token": "",
            "refresh_token": "",
        })
    );
}
