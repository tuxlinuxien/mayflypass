use crate::database;
use crate::server::error::ApiError;
use crate::server::lib::cookies::RefreshTokenCookie;
use crate::server::lib::token;
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use axum::http;
use axum::response::IntoResponse;
use axum::response::Response;
use chrono::Utc;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Deserialize)]
pub struct RefreshInput {
    pub refresh_token: Option<String>,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct RefreshResponse {
    pub access_token: String,
    pub refresh_token: String,
}

pub fn extract_refresh_token_from_cookie(headers: &http::HeaderMap) -> Option<String> {
    headers
        .get(http::header::COOKIE)
        .and_then(|s| RefreshTokenCookie::try_from(s.clone()).ok())
        .and_then(|r| r.token().ok())
}

pub async fn refresh(
    State(state): State<AppState>,
    headers: http::HeaderMap,
    payload: Option<Json<RefreshInput>>,
) -> Result<Response, ApiError> {
    // try to get the the token either from the cookie or json
    let token = extract_refresh_token_from_cookie(&headers)
        .or_else(|| payload.and_then(|t| t.refresh_token.clone()))
        .ok_or(ApiError::InvalidTokenError)?;
    // verify the refresh token is still valid
    let token_info = database::token::get(&state.pool, &token)
        .await?
        .ok_or(ApiError::InvalidTokenError)?;
    // build new tokens
    let new_access_token = token::new(&state.access_token_key, &token_info.account_id, Utc::now())?;
    let new_refresh_token = database::token::generate(&state.pool, &token_info.account_id).await?;
    // add tokens to the response body
    let mut response = Json(RefreshResponse {
        access_token: new_access_token,
        refresh_token: new_refresh_token.clone(),
    })
    .into_response();
    // add the refresh token to the cookie
    let cookie = RefreshTokenCookie::build(&new_refresh_token, !state.dev)?;
    response
        .headers_mut()
        .insert(http::header::SET_COOKIE, cookie.into());
    Ok(response)
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::database;
    use crate::server::testing;

    #[tokio::test]
    async fn test_refresh_no_token() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server.post("/api/refresh").await;
        response.assert_status_unauthorized();
    }

    #[tokio::test]
    async fn test_refresh_invalid_token() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server
            .post("/api/refresh")
            .json(&serde_json::json!({"refresh_token": "invalid-token"}))
            .await;
        response.assert_status_unauthorized();
    }

    #[tokio::test]
    async fn test_refresh_via_json() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = testing::build_default_account(&pool).await;
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        let response = server
            .post("/api/refresh")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await;
        response.assert_status_ok();
        let body = response.json::<RefreshResponse>();
        assert!(!body.refresh_token.is_empty());
        assert!(!body.access_token.is_empty());
        assert_ne!(body.refresh_token, refresh_token);
        let cookie = response.maybe_header(http::header::SET_COOKIE).unwrap();
        let cookie = RefreshTokenCookie::try_from(cookie).unwrap();
        assert_eq!(body.refresh_token, cookie.token().unwrap());
    }

    #[tokio::test]
    async fn test_refresh_via_cookie() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = testing::build_default_account(&pool).await;
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        let cookie = RefreshTokenCookie::try_from(refresh_token).unwrap();
        let response = server
            .post("/api/refresh")
            .add_header(http::header::COOKIE, cookie)
            .await;
        response.assert_status_ok();
        let body = response.json::<RefreshResponse>();
        assert!(!body.refresh_token.is_empty());
        assert!(!body.access_token.is_empty());
    }

    #[tokio::test]
    async fn test_refresh_token_single_use() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = testing::build_default_account(&pool).await;
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        server
            .post("/api/refresh")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await
            .assert_status_ok();

        // second use of the same token must fail
        server
            .post("/api/refresh")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await
            .assert_status_unauthorized();
    }
}
