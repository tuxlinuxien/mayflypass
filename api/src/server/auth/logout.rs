use super::refresh::extract_refresh_token_from_cookie;
use crate::database;
use crate::server::error::ApiError;
use crate::server::state::AppState;
use axum::Json;
use axum::extract::State;
use axum::http;
use axum::response::IntoResponse;
use axum::response::Response;
use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct LogoutInput {
    pub refresh_token: String,
}

pub async fn logout(
    State(state): State<AppState>,
    headers: http::HeaderMap,
    payload: Option<Json<LogoutInput>>,
) -> Result<Response, ApiError> {
    if let Some(token) = extract_refresh_token_from_cookie(&headers) {
        database::token::delete(&state.pool, &token).await?;
    }
    if let Some(token) = payload.map(|p| p.refresh_token.clone()) {
        database::token::delete(&state.pool, &token).await?;
    }
    Ok(http::StatusCode::NO_CONTENT.into_response())
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::database;
    use crate::server::lib::cookies::RefreshTokenCookie;
    use crate::server::testing;

    #[tokio::test]
    async fn test_logout_no_token() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let response = server.post("/api/logout").await;
        response.assert_status_no_content();
    }

    #[tokio::test]
    async fn test_logout_via_json() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        let response = server
            .post("/api/logout")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await;
        response.assert_status_no_content();
    }

    #[tokio::test]
    async fn test_logout_via_cookie() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        let cookie = RefreshTokenCookie::try_from(refresh_token).unwrap();
        let response = server
            .post("/api/logout")
            .add_header(http::header::COOKIE, cookie)
            .await;
        response.assert_status_no_content();
    }

    #[tokio::test]
    async fn test_logout_invalidates_token() {
        let (app, pool) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let refresh_token = database::token::generate(&pool, &account.id).await.unwrap();
        server
            .post("/api/logout")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await
            .assert_status_no_content();
        // token should no longer work for refresh
        server
            .post("/api/refresh")
            .json(&serde_json::json!({"refresh_token": refresh_token}))
            .await
            .assert_status_unauthorized();
    }
}
