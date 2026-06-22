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
    email: String,
    pub kek_m_cost: u32,
    pub kek_t_cost: u32,
    pub kek_p_cost: u32,
    pub kek_output_len: u32,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub kek_salt: Vec<u8>,
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
        email: account.email,
        kek_m_cost: account.kek_m_cost,
        kek_t_cost: account.kek_t_cost,
        kek_p_cost: account.kek_p_cost,
        kek_output_len: account.kek_output_len,
        kek_salt: account.kek_salt,
    }))
}

#[cfg(test)]
mod test {
    use crate::server::lib::token;
    use crate::server::testing;
    use axum::http;
    use chrono::Utc;

    #[tokio::test]
    async fn test_info_with_valid_token() {
        let (app, pool) = testing::init_test_server().await;
        let account = testing::build_default_account(&pool).await;
        let key = [0u8; 32];
        let access_token = token::new(&key, &account.id, Utc::now()).unwrap();
        let server = axum_test::TestServer::new(app);
        let response = server
            .get("/api/account/info")
            .add_header(
                http::header::AUTHORIZATION,
                http::HeaderValue::from_str(&format!("Bearer {access_token}")).unwrap(),
            )
            .await;
        response.assert_status_ok();
        let body = response.json::<serde_json::Value>();
        assert_eq!(body["id"], account.id.to_string());
        assert_eq!(body["email"], account.email);
        assert_eq!(body["kek_m_cost"], account.kek_m_cost);
        assert_eq!(body["kek_t_cost"], account.kek_t_cost);
        assert_eq!(body["kek_p_cost"], account.kek_p_cost);
        assert_eq!(body["kek_output_len"], account.kek_output_len);
        assert_eq!(body["kek_salt"], hex::encode(account.kek_salt));
    }

    #[tokio::test]
    async fn test_info_with_valid_token_password_change() {
        let (app, pool) = testing::init_test_server().await;
        let account = testing::build_default_account(&pool).await;
        let key = [0u8; 32];
        let access_token = token::new(&key, &account.id, Utc::now()).unwrap();
        // simulate a password change so the access token shouldn't be valid anymore
        sqlx::query(
            r"
            UPDATE account
            SET password_updated_at = datetime('now', '+1 minute')
            WHERE id = ?
        ",
        )
        .bind(&account.id)
        .execute(&pool)
        .await
        .unwrap();
        // now run the query
        let server = axum_test::TestServer::new(app);
        let response = server
            .get("/api/account/info")
            .add_header(
                http::header::AUTHORIZATION,
                http::HeaderValue::from_str(&format!("Bearer {access_token}")).unwrap(),
            )
            .await;
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
