use crate::database;
use axum::{
    Json, http,
    response::{IntoResponse, Response},
};
use serde::{Serialize, ser::SerializeMap};
use serde_json::{Value, json};
use thiserror::Error;

#[derive(Debug, Clone)]
pub enum FieldError {
    InvalidEmail(String),
    InvalidCredentials(String),
    InvalidCaptchat(String),
    ValueTooShort(String, i64),
    ValueTooLong(String, i64),
    ValueRange(String, i64, i64),
    ValueRequired(String),
    ValueMismatch(String),
    ValueDuplicated(String),
}

impl Serialize for FieldError {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        match self {
            FieldError::InvalidEmail(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "INVALID_EMAIL")?;
                map.end()
            }
            FieldError::InvalidCredentials(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "INVALID_CREDENTIALS")?;
                map.end()
            }
            FieldError::InvalidCaptchat(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "INVALID_CAPTCHAT")?;
                map.end()
            }
            FieldError::ValueTooShort(field, min) => {
                #[derive(Serialize)]
                struct Params {
                    min: i64,
                }
                let mut map = serializer.serialize_map(Some(3))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_TOO_SHORT")?;
                map.serialize_entry("params", &Params { min: *min })?;
                map.end()
            }
            FieldError::ValueTooLong(field, max) => {
                #[derive(Serialize)]
                struct Params {
                    max: i64,
                }
                let mut map = serializer.serialize_map(Some(3))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_TOO_LONG")?;
                map.serialize_entry("params", &Params { max: *max })?;
                map.end()
            }
            FieldError::ValueRange(field, min, max) => {
                #[derive(Serialize)]
                struct Params {
                    min: i64,
                    max: i64,
                }
                let mut map = serializer.serialize_map(Some(3))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_RANGE")?;
                map.serialize_entry(
                    "params",
                    &Params {
                        min: *min,
                        max: *max,
                    },
                )?;
                map.end()
            }
            FieldError::ValueRequired(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_REQUIRED")?;
                map.end()
            }
            FieldError::ValueMismatch(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_MISMATCH")?;
                map.end()
            }
            FieldError::ValueDuplicated(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_DUPLICATED")?;
                map.end()
            }
        }
    }
}

#[derive(Debug, Error)]
pub enum ApiError {
    #[error("internal error")]
    InternalError,
    #[error("internal error: {0}")]
    AnyhowError(#[from] anyhow::Error),
    #[error("database error: {0}")]
    DatabaseError(#[from] database::error::Error),
    #[error("invalid token")]
    InvalidTokenError,
    #[error("unauthorized")]
    UnauthorizedError,
    #[error("unprocessable content: {0}")]
    UnprocessableContent(Value),
    #[error("bad request field errors")]
    BadRequestFieldErrors(Vec<FieldError>),
}

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        match self {
            ApiError::InternalError => (
                http::StatusCode::INTERNAL_SERVER_ERROR,
                Json(json!({"error": "internal error"})),
            )
                .into_response(),
            ApiError::AnyhowError(_) => (
                http::StatusCode::INTERNAL_SERVER_ERROR,
                Json(json!({"error": "internal error"})),
            )
                .into_response(),
            ApiError::DatabaseError(_) => (
                http::StatusCode::INTERNAL_SERVER_ERROR,
                Json(json!({"error": "internal error"})),
            )
                .into_response(),
            ApiError::InvalidTokenError => (
                http::StatusCode::UNAUTHORIZED,
                Json(json!({"error": "unauthorized"})),
            )
                .into_response(),
            ApiError::UnauthorizedError => (
                http::StatusCode::UNAUTHORIZED,
                Json(json!({"error": "unauthorized"})),
            )
                .into_response(),
            ApiError::BadRequestFieldErrors(e) => {
                (http::StatusCode::BAD_REQUEST, Json(json!({"errors": e}))).into_response()
            }
            ApiError::UnprocessableContent(e) => {
                (http::StatusCode::UNPROCESSABLE_ENTITY, Json(e)).into_response()
            }
        }
    }
}
