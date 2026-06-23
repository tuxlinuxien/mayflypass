use crate::database;
use axum::{
    Json, http,
    response::{IntoResponse, Response},
};
use serde::{Serialize, ser::SerializeMap};
use serde_json::{Value, json};
use thiserror::Error;
use validator::ValidateEmail;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FieldError {
    EmailInvalid(String),
    CredentialsInvalid(String),
    CaptchatInvalid(String),
    #[allow(unused)]
    ValueTooShort(String, i64),
    ValueTooLong(String, i64),
    #[allow(unused)]
    ValueRange(String, i64, i64),
    ValueRequired(String),
    #[allow(unused)]
    ValueMismatch(String),
    ValueDuplicated(String),
    ValueLength(String, i64),
}

impl FieldError {
    pub fn check_required(field: &str, value: &str) -> Option<FieldError> {
        if value.is_empty() {
            Some(Self::ValueRequired(field.to_string()))
        } else {
            Option::None
        }
    }

    pub fn check_too_long(field: &str, value: &str, max: i64) -> Option<FieldError> {
        if value.len() > max as usize {
            Some(Self::ValueTooLong(field.to_string(), max))
        } else {
            Option::None
        }
    }

    #[allow(unused)]
    pub fn check_too_short(field: &str, value: &str, min: i64) -> Option<FieldError> {
        if value.len() < min as usize {
            Some(Self::ValueTooShort(field.to_string(), min))
        } else {
            Option::None
        }
    }

    pub fn check_email_invalid(field: &str, value: &str) -> Option<FieldError> {
        if !value.validate_email() {
            Some(Self::EmailInvalid(field.to_string()))
        } else {
            Option::None
        }
    }

    #[allow(unused)]
    pub fn check_value_mismatch(field: &str, cmp1: &str, cmp2: &str) -> Option<FieldError> {
        if cmp1 != cmp2 {
            Some(Self::ValueMismatch(field.to_string()))
        } else {
            Option::None
        }
    }

    pub fn check_value_length(field: &str, value: &str, len: i64) -> Option<FieldError> {
        if value.len() != len as usize {
            Some(Self::ValueLength(field.to_string(), len))
        } else {
            Option::None
        }
    }
}

impl Serialize for FieldError {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        match self {
            FieldError::EmailInvalid(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "EMAIL_INVALID")?;
                map.end()
            }
            FieldError::CredentialsInvalid(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "CREDENTIALS_INVALID")?;
                map.end()
            }
            FieldError::CaptchatInvalid(field) => {
                let mut map = serializer.serialize_map(Some(2))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "CAPTCHAT_INVALID")?;
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
            FieldError::ValueLength(field, len) => {
                #[derive(Serialize)]
                struct Params {
                    len: i64,
                }
                let mut map = serializer.serialize_map(Some(3))?;
                map.serialize_entry("field", field)?;
                map.serialize_entry("code", "VALUE_LENGTH")?;
                map.serialize_entry("params", &Params { len: *len })?;
                map.end()
            }
        }
    }
}

#[derive(Debug, Error)]
pub enum ApiError {
    #[error("internal error: {0}")]
    InternalError(#[from] anyhow::Error),
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
    #[error("not found")]
    NotFound,
}

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        tracing::error!("api error: {:?}", self);
        match self {
            ApiError::InternalError(_) => (
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
            ApiError::NotFound => (
                http::StatusCode::NOT_FOUND,
                Json(json!({"error": "not found"})),
            )
                .into_response(),
        }
    }
}
