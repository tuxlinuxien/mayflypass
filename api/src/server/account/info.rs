use axum::{Extension, Json, extract::State};
use serde::Serialize;
use serde_with::serde_as;
use uuid::Uuid;

use crate::{
    database,
    server::{error::ApiError, middleware::AuthUserId, state::AppState},
};

#[serde_as]
#[derive(Debug, Serialize)]
pub struct InfoResponse {
    id: Uuid,
    username: String,
}

pub async fn info(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
) -> Result<Json<InfoResponse>, ApiError> {
    let account = database::account::get_by_id(&state.pool, &account_id)
        .await?
        .ok_or(ApiError::UnauthorizedError)?;
    Ok(Json(InfoResponse {
        id: account.id,
        username: account.username,
    }))
}

#[cfg(test)]
mod test {
    use crate::server::testing;

    #[tokio::test]
    async fn test_info_with_valid_token() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        let response = server.get("/api/account/info").await;
        response.assert_status_ok();
        let body = response.json::<serde_json::Value>();
        assert_eq!(body["id"], account.id.to_string());
        assert_eq!(body["username"], account.username);
    }

    #[tokio::test]
    async fn test_info_with_valid_token_password_change() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;
        // simulate a password change so the access token shouldn't be valid anymore
        sqlx::query(
            r"
            UPDATE account
            SET password_updated_at = datetime('now', '+1 minute')
            WHERE id = ?
        ",
        )
        .bind(&account.id)
        .execute(&state.pool)
        .await
        .unwrap();
        // now run the query

        let response = server.get("/api/account/info").await;
        response.assert_status_unauthorized();
    }

    #[tokio::test]
    async fn test_info_with_no_token() {
        let (app, _) = testing::init_test_server().await;
        let server = axum_test::TestServer::new(app);

        let response = server.get("/api/account/info").await;
        response.assert_status_unauthorized();
    }
}
