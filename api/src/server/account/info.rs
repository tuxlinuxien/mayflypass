use axum::{Extension, Json, extract::State};
use serde::Serialize;

use crate::{
    database,
    server::{error::ApiError, middleware::AuthUserId, state::AppState},
};

#[derive(Debug, Serialize)]
pub struct InfoResponse {
    id: String,
    email: String,
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
    }))
}

#[cfg(test)]
mod test {
    use crate::database;
    use crate::server::lib::token;
    use crate::server::testing;
    use axum::http;
    use chrono::Utc;

    #[tokio::test]
    async fn test_info_with_valid_token() {
        let (app, pool) = testing::init_test_server().await;
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
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
        assert_eq!(body["id"], account.id);
        assert_eq!(body["email"], account.email);
    }

    #[tokio::test]
    async fn test_info_with_valid_token_password_change() {
        let (app, pool) = testing::init_test_server().await;
        let account = database::account::insert(
            &pool,
            database::account::AccountInsert {
                email: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let access_token = token::new(&key, &account.id, Utc::now()).unwrap();
        // simulate a password change so the access token should be valid anymore
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
