use crate::database;
use crate::server::error::{ApiError, FieldError};
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use serde_with::serde_as;

#[serde_as]
#[derive(Debug, Clone, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(default, deserialize_with = "serde_trim::string_trim")]
    pub email: String,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub password: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub challenge_key: Vec<u8>,
    pub challenge_nonce: u64,
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
            // challenge_key
            FieldError::check_required("challenge_key", &self.challenge_key).or(
                FieldError::check_value_length("challenge_key", &self.challenge_key, 32),
            ),
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
    if !database::challenge::verify(&state.pool, &payload.challenge_key, payload.challenge_nonce)
        .await?
    {
        return Err(ApiError::BadRequestFieldErrors(vec![
            FieldError::ChallengeInvalid("challenge_nonce".into()),
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

pub async fn challenge(
    State(state): State<AppState>,
) -> Result<Json<database::challenge::ChallengeResult>, ApiError> {
    // create new captchat.
    let res = database::challenge::generate(&state.pool, state.difficulty)
        .await
        .map_err(|e| ApiError::InternalError(anyhow::anyhow!("generate challenge: {:?}", e)))?;
    return Ok(Json(res));
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::database::{self, challenge};
    use crate::server::testing;

    #[tokio::test]
    async fn test_register_validate() {
        let base = RegisterInput {
            email: "test@mail.com".into(),
            password: [0u8].repeat(32),
            challenge_key: [0u8].repeat(32),
            challenge_nonce: 0,
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
        input.challenge_key = [0u8].repeat(0);
        let res = input.validate();
        assert!(res.is_err());
        let ApiError::BadRequestFieldErrors(val) = res.err().unwrap() else {
            panic!("BadRequestFieldErrors");
        };
        assert_eq!(val, vec![FieldError::ValueRequired("challenge_key".into())]);
    }

    #[tokio::test]
    async fn test_register_invalid_email() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "notanemail",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_bad_request();
    }

    #[tokio::test]
    async fn test_register_short_password() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "1234",
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_bad_request();
    }

    #[tokio::test]
    async fn test_register_invalid_challenge_nonce() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, challenge::DIFFICULTY::EASY)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                &FieldError::ChallengeInvalid("challenge_nonce".into())
            ]}),
        );
    }

    #[tokio::test]
    async fn test_register_reuse_challenge() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, challenge::DIFFICULTY::NONE)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key.clone()),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_ok();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test1@mail.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_bad_request();
    }

    #[tokio::test]
    async fn test_register_valid() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_ok();
    }

    #[tokio::test]
    async fn test_register_duplicated() {
        let (app, state) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "Test@MAIL.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
            }))
            .await;
        response.assert_status_ok();
        let challenge = database::challenge::generate(&state.pool, state.difficulty)
            .await
            .unwrap();
        let response = server
            .post("/api/register")
            .json(&serde_json::json!({
                "email": "test@mail.com",
                "password": "0".repeat(64),
                "challenge_key": hex::encode(challenge.key),
                "challenge_nonce": 0,
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
        assert!(json["key"].as_str().unwrap().len() == 64);
        assert!(json["salt"].as_str().unwrap().len() == 32);
        assert!(json["difficulty"].as_str().unwrap().len() == 64);
    }
}
