use axum::{
    Router,
    routing::{get, post},
};
mod account;
mod auth;
mod error;
mod extractor;
mod lib;
mod middleware;
mod state;
#[cfg(test)]
mod testing;

pub fn create_routes(state: state::AppState) -> Router<state::AppState> {
    // public
    let public = Router::new()
        .route("/api/register", post(auth::register))
        .route("/api/register", get(auth::captchat))
        .route("/api/login", post(auth::login))
        .route("/api/refresh", post(auth::refresh))
        .route("/api/logout", post(auth::logout));
    // authenticated
    let private = Router::new()
        .route("/api/account/info", get(account::info))
        .route_layer(axum::middleware::from_fn_with_state(
            state,
            middleware::auth,
        ));
    return public.merge(private);
}

pub async fn init(interface: &str, pool: sqlx::SqlitePool) {
    let state = state::AppState {
        pool: pool,
        access_token_key: [0u8; 32],
    };
    let router = create_routes(state.clone());
    let router = router.with_state(state);
    let listener = tokio::net::TcpListener::bind(interface).await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
