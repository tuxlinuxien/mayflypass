use axum::{
    Json,
    extract::rejection::{self, JsonRejection},
    http,
    response::{IntoResponse, Response},
};
use serde_json::json;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ApiError {
    #[error(transparent)]
    JsonRejection(#[from] JsonRejection),
    #[error("invalid field")]
    InvalidField { field: String, message: String },
}

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        match self {
            ApiError::JsonRejection(rejection) => {
                let body = rejection.body_text();
                // body_text() format: "Failed to ...: <serde message>" — strip the static prefix
                let detail = body.splitn(2, ": ").nth(1).unwrap_or(&body).to_owned();
                (rejection.status(), Json(json!({ "error": detail }))).into_response()
            }
            ApiError::InvalidField { field, message } => (
                http::status::StatusCode::BAD_REQUEST,
                Json(json!({"error": {field: message}})),
            )
                .into_response(),
        }
    }
}
