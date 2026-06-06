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

#[tokio::test]
async fn test_generate() {
    let (app, _) = super::testing::init_test_server().await;
    let server = axum_test::TestServer::new(app);

    let resp = server.get("/api/captchat").await;
    resp.assert_status_ok();

    let json = resp.json::<serde_json::Value>();
    assert!(!json["id"].as_str().unwrap().is_empty());
    assert!(!json["image"].as_str().unwrap().is_empty());
}
