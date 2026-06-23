use crate::database;
use crate::server::error::{ApiError, FieldError};
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use serde_with::serde_as;
use uuid::Uuid;

#[serde_as]
#[derive(Debug, Clone, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub password: Vec<u8>,
    pub c_id: Uuid,
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub c_code: String,
}

impl RegisterInput {
    fn validate(&mut self) -> Result<(), ApiError> {
        // normalize the email
        self.email = self.email.to_lowercase();

        let errors: Vec<FieldError> = vec![
            // email
            FieldError::check_required("email", &self.email)
                .or(FieldError::check_too_long("email", &self.email, 50))
                .or(FieldError::check_email_invalid("email", &self.email)),
            // password
            FieldError::check_required("password", &self.password).or(
                FieldError::check_value_length("password", &self.password, 32),
            ),
            // c_code
            FieldError::check_required("c_code", &self.c_code).or(FieldError::check_too_long(
                "c_code",
                &self.password,
                128,
            )),
        ]
        .into_iter()
        .flatten()
        .collect();

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

    // only test the captchat is dev is false
    if !state.dev
        && !database::captchat::verify(&state.pool, &payload.c_id, &payload.c_code).await?
    {
        return Err(ApiError::BadRequestFieldErrors(vec![
            FieldError::CaptchatInvalid("c_code".into()),
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
            _ => {
                Err(anyhow::anyhow!("db error: {:?}", e))?;
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
        .map_err(|e| ApiError::InternalError(anyhow::anyhow!("generate captchat: {:?}", e)))?;
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
        let base = RegisterInput {
            email: "test@mail.com".into(),
            password: [0u8].repeat(32),
            c_id: Uuid::new_v4(),
            c_code: "00000".into(),
        };
        // bad email
        let mut input = base.clone();
        input.email = "no email".into();
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::EmailInvalid("email".into())]);

        // empty email
        let mut input = base.clone();
        input.email = "".into();
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::ValueRequired("email".into())]);

        // email too long
        let mut input = base.clone();
        input.email = "test.tttttttttttttttttttttttttttttttttttttttttt@mail.com".into();
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::ValueTooLong("email".into(), 50)]);

        // password too short
        let mut input = base.clone();
        input.password = [0u8].repeat(31);
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::ValueLength("password".into(), 32)]);

        // missing c_code
        let mut input = base.clone();
        input.c_code = "".into();
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::ValueRequired("c_code".into())]);
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
                "password": "0".repeat(64),
                "c_id": cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
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
                "c_id": cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
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
                "password": "00000000",
                "c_id": cap.id,
                "c_code": "0000",
            }))
            .await;
        response.assert_status_bad_request();
    }

    #[tokio::test]
    async fn test_register_invalid_c_id() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "0".repeat(64),
                "c_id": Uuid::new_v4(),
                "c_code": "0000",
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                &FieldError::CaptchatInvalid("c_code".into())
            ]}),
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
                "password": "0".repeat(64),
                "c_id": &cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                &FieldError::CaptchatInvalid("c_code".into())
            ]}),
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
                "password": "0".repeat(64),
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
                "password": "0".repeat(64),
                "c_id": &cap.id,
                "c_code": code,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                &FieldError::ValueDuplicated("email".into())
            ]}),
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
