use crate::server::error::ApiError;
use axum::{
    extract::{FromRequest, OptionalFromRequest, rejection::JsonRejection},
    response::{IntoResponse, Response},
};
use serde::{Serialize, de::DeserializeOwned};
use std::ops::{Deref, DerefMut};

pub struct Json<T>(pub T);

impl<T, S> FromRequest<S> for Json<T>
where
    T: DeserializeOwned + Send,
    S: Send + Sync,
{
    type Rejection = ApiError;

    async fn from_request(
        req: axum::http::Request<axum::body::Body>,
        state: &S,
    ) -> Result<Self, Self::Rejection> {
        match <axum::Json<T> as FromRequest<S>>::from_request(req, state).await {
            Ok(axum::Json(value)) => Ok(Json(value)),
            Err(rejection) => Err(ApiError::from(rejection)),
        }
    }
}

impl<T, S> OptionalFromRequest<S> for Json<T>
where
    T: DeserializeOwned + Send,
    S: Send + Sync,
{
    type Rejection = ApiError;

    async fn from_request(
        req: axum::http::Request<axum::body::Body>,
        state: &S,
    ) -> Result<Option<Self>, Self::Rejection> {
        match <axum::Json<T> as OptionalFromRequest<S>>::from_request(req, state).await {
            Ok(None) => Ok(None),
            Ok(Some(axum::Json(value))) => Ok(Some(Json(value))),
            Err(rejection) => Err(ApiError::from(rejection)),
        }
    }
}

impl<T> Deref for Json<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl<T> DerefMut for Json<T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

impl<T: Serialize> IntoResponse for Json<T> {
    fn into_response(self) -> Response {
        axum::Json(self.0).into_response()
    }
}

impl From<JsonRejection> for ApiError {
    fn from(value: JsonRejection) -> Self {
        match value {
            JsonRejection::JsonSyntaxError(e) => ApiError::UnprocessableContent(e.into()),
            JsonRejection::JsonDataError(e) => ApiError::BadRequest(e.into()),
            JsonRejection::MissingJsonContentType(e) => ApiError::BadRequest(e.into()),
            JsonRejection::BytesRejection(e) => ApiError::InternalError(e.into()),
            _ => ApiError::BadRequest(anyhow::anyhow!("unknown")),
        }
    }
}
