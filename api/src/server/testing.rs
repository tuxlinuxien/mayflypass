use super::state;
use crate::database;
use axum::Router;

pub async fn init_test_server() -> (Router, sqlx::SqlitePool) {
    let pool = database::create_pool("sqlite::memory:", 1).await.unwrap();
    database::run_migrations(&pool).await.unwrap();
    let state = state::AppState {
        pool: pool.clone(),
        access_token_key: [0u8; 32],
    };
    let router = super::create_routes(state.clone());
    let router = router.with_state(state);
    (router, pool)
}
