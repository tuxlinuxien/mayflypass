use axum::extract::{FromRequest, OptionalFromRequest, Request};
use serde::de::DeserializeOwned;
use serde_json::json;

use crate::server::error::ApiError;

pub struct JsonInput<T>(pub T);

impl<T> std::ops::Deref for JsonInput<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl<T> std::ops::DerefMut for JsonInput<T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

impl<T, S> FromRequest<S> for JsonInput<T>
where
    T: DeserializeOwned,
    S: Send + Sync,
{
    type Rejection = ApiError;

    async fn from_request(req: Request, state: &S) -> Result<Self, Self::Rejection> {
        <axum::Json<T> as FromRequest<S>>::from_request(req, state)
            .await
            .map(|axum::Json(val)| JsonInput(val))
            .map_err(|_| {
                ApiError::UnprocessableContent(json!({
                    "title": "invalid payload",
                }))
            })
    }
}

impl<T, S> OptionalFromRequest<S> for JsonInput<T>
where
    T: DeserializeOwned,
    S: Send + Sync,
{
    type Rejection = ApiError;

    async fn from_request(req: Request, state: &S) -> Result<Option<Self>, Self::Rejection> {
        <axum::Json<T> as OptionalFromRequest<S>>::from_request(req, state)
            .await
            .map(|opt| opt.map(|axum::Json(val)| JsonInput(val)))
            .map_err(|_| {
                ApiError::UnprocessableContent(json!({
                    "title": "invalid payload",
                }))
            })
    }
}
