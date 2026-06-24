use super::state;
use crate::{
    database::{self, account::AccountResult},
    server::lib::token,
};
use axum::{Router, http};
use axum_test::TestServer;
use chrono::Utc;

pub async fn init_test_server() -> (Router, state::AppState) {
    let pool = database::create_pool("sqlite::memory:", 1).await.unwrap();
    database::run_migrations(&pool).await.unwrap();
    let state = state::AppState {
        pool: pool.clone(),
        access_token_key: [0u8; 32],
        dev: false,
        difficulty: database::challenge::DIFFICULTY::NONE,
    };
    let router = super::create_routes(state.clone());
    let router = router.with_state(state.clone());
    (router, state)
}

pub async fn build_default_account(pool: &sqlx::SqlitePool) -> AccountResult {
    database::account::insert(
        pool,
        &database::account::AccountInsert {
            email: "test@mail.com".into(),
            password: [0u8].repeat(32),
        },
    )
    .await
    .unwrap()
}

pub async fn build_user_server(account: &AccountResult, app: &Router) -> TestServer {
    let key = [0u8; 32];
    let access_token = token::new(&key, &account.id, Utc::now()).unwrap();
    let mut server = axum_test::TestServer::new(app.clone());
    server.add_header(
        http::header::AUTHORIZATION,
        http::HeaderValue::from_str(&format!("Bearer {}", access_token)).unwrap(),
    );
    return server;
}
