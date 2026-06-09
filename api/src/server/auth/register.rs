use crate::database;
use crate::server::error::{ApiError, FieldError};
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use serde_json::json;
use uuid::Uuid;
use validator::ValidateEmail;

#[derive(Debug, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde(deserialize_with = "serde_trim::string_trim")]
    pub password: String,
    #[serde(deserialize_with = "serde_trim::string_trim")]
    pub password_repeat: String,
    pub c_id: Uuid,
    #[serde(deserialize_with = "serde_trim::string_trim")]
    pub c_code: String,
}

impl RegisterInput {
    async fn validate(&mut self) -> Result<(), ApiError> {
        let mut errors = vec![];
        // email
        self.email = self.email.to_lowercase();
        if !self.email.validate_email() {
            errors.push(FieldError("email", "Invalid email."));
        }
        // password
        if self.password.len() < 8 {
            errors.push(FieldError(
                "password",
                "Must be at least 8 characters long.",
            ));
        }
        // password_repeat
        if self.password != self.password_repeat {
            errors.push(FieldError("password_repeat", "Password mismatch."));
        }
        //
        if self.c_code.is_empty() {
            errors.push(FieldError("c_code", "Field required."));
        }

        if errors.is_empty() {
            return Ok(());
        }
        Err(ApiError::BadRequest(json!({
            "errors": errors,
        })))
    }
}

pub async fn register(
    State(state): State<AppState>,
    Json(mut payload): Json<RegisterInput>,
) -> Result<(), ApiError> {
    // normalize email and check if it's valid.
    payload.validate().await?;

    if !database::captchat::verify(&state.pool, &payload.c_id, &payload.c_code).await? {
        return Err(ApiError::BadRequest(json!({
            "errors": vec![FieldError("c_code", "Invalid verification code.")],
        })));
    }

    let new_user = &database::account::AccountInsert {
        email: payload.email.clone(),
        password: payload.password.clone(),
    };
    match database::account::insert(&state.pool, new_user).await {
        Ok(_) => {}
        Err(e) => match e {
            database::error::Error::UniqueViolation { .. } => {
                return Err(ApiError::BadRequest(json!({
                    "errors": vec![FieldError("email", "This account already exists.")],
                })));
            }
            _ => return Err(ApiError::InternalError),
        },
    }
    Ok(())
}

pub async fn captchat(
    State(state): State<AppState>,
) -> Result<Json<database::captchat::CaptchatResult>, ApiError> {
    // create new captchat.
    let (res, _) = database::captchat::generate(&state.pool)
        .await
        .map_err(|_| ApiError::InternalError)?;
    return Ok(Json(res));
}

#[cfg(test)]
mod test {
    use uuid::Uuid;

    use crate::database;
    use crate::server::testing;

    #[tokio::test]
    async fn test_register_invalid_email() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let (cap, code) = database::captchat::generate(&pool).await.unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "notanemail",
                "password": "password123",
                "password_repeat": "password123",
                "c_id": cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();

        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "email", "message": "Invalid email."}]})
        );
    }

    #[tokio::test]
    async fn test_register_short_password() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let (cap, code) = database::captchat::generate(&pool).await.unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "1234",
                "password_repeat": "1234",
                "c_id": cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "password", "message": "Must be at least 8 characters long."}]})
        );
    }

    #[tokio::test]
    async fn test_register_repeat_password() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let (cap, code) = database::captchat::generate(&pool).await.unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "123456789",
                "password_repeat": "1234567890",
                 "c_id": cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "password_repeat", "message": "Password mismatch."}]})
        );
    }

    #[tokio::test]
    async fn test_register_invalid_code() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let (cap, _) = database::captchat::generate(&pool).await.unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "123456789",
                "password_repeat": "123456789",
                 "c_id": cap.id,
                "c_code": "0000",
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "c_code", "message": "Invalid verification code."}]})
        );
    }

    #[tokio::test]
    async fn test_register_invalid_c_id() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "123456789",
                "password_repeat": "123456789",
                 "c_id": Uuid::new_v4(),
                "c_code": "0000",
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "c_code", "message": "Invalid verification code."}]})
        );
    }

    #[tokio::test]
    async fn test_register_reuse_c_id() {
        let (app, pool) = testing::init_test_server().await;
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
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "c_code", "message": "Invalid verification code."}]})
        );
    }

    #[tokio::test]
    async fn test_register_valid() {
        let (app, pool) = testing::init_test_server().await;
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
        let (app, pool) = testing::init_test_server().await;
        // insert account
        let _ = testing::build_default_account(&pool).await;
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
        assert_eq!(
            body,
            serde_json::json!({"errors": [{"field": "email", "message": "This account already exists."}]})
        );
    }

    #[tokio::test]
    async fn test_generate() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let resp = server.get("/api/register").await;
        resp.assert_status_ok();
        let json = resp.json::<serde_json::Value>();
        assert!(!json["id"].as_str().unwrap().is_empty());
        assert!(!json["image"].as_str().unwrap().is_empty());
    }
}
