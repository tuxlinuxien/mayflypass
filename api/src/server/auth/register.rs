use crate::database;
use crate::server::error::{ApiError, FieldError};
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
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
    fn validate(&mut self) -> Result<(), ApiError> {
        let mut errors = vec![];
        // email
        self.email = self.email.to_lowercase();
        if !self.email.validate_email() {
            errors.push(FieldError::InvalidEmail("email".into()));
        }
        // password
        if self.password.len() < 8 {
            errors.push(FieldError::ValueTooShort("password".into(), 8));
        }
        // password_repeat
        if self.password != self.password_repeat {
            errors.push(FieldError::ValueMismatch("password_repeat".into()));
        }
        //
        if self.c_code.is_empty() {
            errors.push(FieldError::ValueRequired("c_code".into()));
        }

        if errors.is_empty() {
            return Ok(());
        }
        Err(ApiError::BadRequestFieldErrors(errors))
    }
}

pub async fn register(
    State(state): State<AppState>,
    Json(mut payload): Json<RegisterInput>,
) -> Result<(), ApiError> {
    // normalize email and check if it's valid.
    payload.validate()?;

    if !database::captchat::verify(&state.pool, &payload.c_id, &payload.c_code).await? {
        return Err(ApiError::BadRequestFieldErrors(vec![
            FieldError::InvalidCaptchat("c_code".into()),
        ]));
    }

    let new_user = &database::account::AccountInsert {
        email: payload.email.clone(),
        password: payload.password.clone(),
    };
    match database::account::insert(&state.pool, new_user).await {
        Ok(_) => {}
        Err(e) => match e {
            database::error::Error::UniqueViolation { .. } => {
                return Err(ApiError::BadRequestFieldErrors(vec![
                    FieldError::ValueDuplicated("email".into()),
                ]));
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
    use super::*;
    use crate::database;
    use crate::server::testing;
    use uuid::Uuid;

    #[tokio::test]
    async fn test_register_validate() {
        let mut v = RegisterInput {
            email: "".into(),
            password: "".into(),
            password_repeat: "".into(),
            c_id: Uuid::new_v4(),
            c_code: "".into(),
        };
        let res = v.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(
            serde_json::json!([
                {"field":"email", "message": "Invalid email."},
                {"field": "password", "message": "Must be at least 8 characters long."},
                {"field": "c_code", "message": "Field required."}
            ]),
            serde_json::json!(val),
        );
    }

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
                "email": "Test@MAIL.com",
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
