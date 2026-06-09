use crate::database;
use axum::{
    Json, http,
    response::{IntoResponse, Response},
};
use serde::{
    Serialize,
    ser::{SerializeMap, Serializer},
};
use serde_json::{Value, json};
use thiserror::Error;

#[derive(Debug, Clone)]
pub struct FieldError<T>(pub T, pub T);

impl<T: ToString> Serialize for FieldError<T> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut map = serializer.serialize_map(Some(2))?;
        map.serialize_entry("field", &self.0.to_string())?;
        map.serialize_entry("message", &self.1.to_string())?;
        map.end()
    }
}

#[derive(Debug, Error)]
pub enum ApiError {
    #[error("invalid field")]
    InvalidField { field: String, message: String },
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
    #[error("bad request: {0}")]
    BadRequest(Value),
    #[error("unprocessable content: {0}")]
    UnprocessableContent(Value),
}

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        match self {
            ApiError::InvalidField { field, message } => (
                http::StatusCode::BAD_REQUEST,
                Json(json!({"error": {field: message}})),
            )
                .into_response(),
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
            ApiError::BadRequest(e) => (http::StatusCode::BAD_REQUEST, Json(e)).into_response(),
            ApiError::UnprocessableContent(e) => {
                (http::StatusCode::UNPROCESSABLE_ENTITY, Json(e)).into_response()
            }
        }
    }
}
