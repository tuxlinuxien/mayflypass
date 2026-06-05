use axum::{Router, routing::post};
mod account;
mod error;
mod extractor;

pub async fn init(interface: &str) {
    let public: Router = Router::new().route("/api/register", post(account::register));
    let listener = tokio::net::TcpListener::bind(interface).await.unwrap();
    axum::serve(listener, public).await.unwrap();
}
