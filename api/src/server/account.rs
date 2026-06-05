use super::error::ApiError;
use axum::Json;

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

pub async fn register(Json(mut payload): Json<RegisterInput>) -> Result<(), ApiError> {
    payload.email = payload.email.to_lowercase();
    if payload.password.len() < 8 {
        Err(super::error::ApiError::InvalidField {
            field: "password".into(),
            message: "must be at least 8 char long".into(),
        })?;
    }
    if payload.password != payload.password_repeat {
        Err(super::error::ApiError::InvalidField {
            field: "password".into(),
            message: "mismatch".into(),
        })?;
    }
    println!("{:?}", payload);
    Ok(())
}
