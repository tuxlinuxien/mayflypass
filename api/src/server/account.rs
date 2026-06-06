use crate::database;

use super::error::ApiError;
use super::state::AppState;
use axum::Json;
use axum::extract::State;
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
