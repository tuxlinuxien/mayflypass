use axum::{Json, extract::State};

use crate::{
    database,
    server::{error::ApiError, state::AppState},
};

pub async fn generate(
    State(state): State<AppState>,
) -> Result<Json<database::captchat::CaptchatResult>, ApiError> {
    // create new captchat.
    let res = database::captchat::generate(&state.pool)
        .await
        .map_err(|_| ApiError::InternalError)?;
    return Ok(Json(res));
}
