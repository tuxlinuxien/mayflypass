use axum::{
    Json, http,
    response::{IntoResponse, Response},
};
use serde_json::{Value, json};
use thiserror::Error;

use crate::database;

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
    #[error("bad request")]
    BadRequest(Value),
    #[error("unprocessable content")]
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
