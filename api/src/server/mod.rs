use axum::{
    Router,
    routing::{get, post},
};

mod account;
mod captchat;
mod error;
mod extractor;
mod state;
#[cfg(test)]
mod testing;

pub fn create_routes() -> Router<state::AppState> {
    let public = Router::new()
        .route("/api/register", post(account::register))
        .route("/api/captchat", get(captchat::generate))
        .route("/api/login", post(account::login));
    return public;
}

pub async fn init(interface: &str, pool: sqlx::SqlitePool) {
    let state = state::AppState {
        pool: pool,
        access_token_key: [0u8; 32],
    };
    let router = create_routes();
    let router = router.with_state(state);
    let listener = tokio::net::TcpListener::bind(interface).await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
