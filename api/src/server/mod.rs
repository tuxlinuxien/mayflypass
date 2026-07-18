use axum::{
    Router,
    extract::Request,
    http,
    middleware::Next,
    response::Response,
    routing::{get, post},
};
use tower_http::{cors::CorsLayer, limit::RequestBodyLimitLayer};

use crate::database::challenge::DIFFICULTY;
mod account;
mod auth;
mod error;
mod json;
mod lib;
mod middleware;
mod state;
mod storage;
#[cfg(test)]
mod testing;

fn fmt_bytes(bytes: u64) -> String {
    if bytes < 1_024 {
        format!("{}B", bytes)
    } else if bytes < 1_024 * 1_024 {
        format!("{:.1}KB", bytes as f64 / 1_024.0)
    } else {
        format!("{:.1}MB", bytes as f64 / (1_024.0 * 1_024.0))
    }
}

async fn log(req: Request, next: Next) -> Response {
    let size = req
        .headers()
        .get(http::header::CONTENT_LENGTH)
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.parse::<u64>().ok())
        .unwrap_or(0);

    let method = req.method().clone();
    let uri = req.uri().clone();
    let start = std::time::Instant::now();
    let res = next.run(req).await;

    if res.status().is_success() {
        tracing::info!(
            method = %method,
            uri = %uri,
            status = res.status().as_u16(),
            elapsed_ms = start.elapsed().as_millis(),
            request_body_len = %fmt_bytes(size),
        );
    } else {
        tracing::error!(
            method = %method,
            uri = %uri,
            status = res.status().as_u16(),
            elapsed_ms = start.elapsed().as_millis(),
            request_body_len = %fmt_bytes(size),
        );
    }
    res
}

pub fn create_routes(state: state::AppState) -> Router<state::AppState> {
    // public
    let public = Router::new()
        .route("/api/register", post(auth::register))
        .route("/api/register", get(auth::challenge))
        .route("/api/login", post(auth::login))
        .route("/api/refresh", post(auth::refresh))
        .route("/api/logout", post(auth::logout));
    // authenticated
    let private = Router::new()
        // account
        .route("/api/account/info", get(account::info))
        .route("/api/account/password", post(account::update_password))
        // storage
        .route("/api/storage", post(storage::upsert))
        .route("/api/storage", get(storage::select))
        .route_layer(axum::middleware::from_fn_with_state(
            state,
            middleware::auth,
        ));
    return public.merge(private);
}

pub async fn init(interface: &str, pool: sqlx::SqlitePool, dev: bool, difficulty: DIFFICULTY) {
    let state = state::AppState {
        pool: pool,
        access_token_key: [0u8; 32],
        dev: dev,
        difficulty: difficulty,
    };
    let router = create_routes(state.clone());
    let router = router
        .layer(axum::middleware::from_fn(log))
        .layer(CorsLayer::permissive())
        .layer(RequestBodyLimitLayer::new(2 * 1024 * 1024))
        .with_state(state);
    let listener = tokio::net::TcpListener::bind(interface).await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
