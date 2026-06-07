use crate::database;
use crate::server::error::ApiError;
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use validator::ValidateEmail;

#[derive(Debug, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub password: String,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub password_repeat: String,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub c_id: String,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
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
    use crate::database;
    use crate::server::testing;

    #[tokio::test]
    async fn test_register_invalid_email() {
        let (app, _) = testing::init_test_server().await;
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
        let (app, _) = testing::init_test_server().await;
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
        let (app, _) = testing::init_test_server().await;
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
        let (app, pool) = testing::init_test_server().await;
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
        let (app, pool) = testing::init_test_server().await;
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
        let body = response.json::<serde_json::Value>();
        assert_eq!(body, serde_json::json!({"error": {"code": "invalid"}}));
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
        assert_eq!(body, serde_json::json!({"error": {"email": "duplicated"}}));
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
