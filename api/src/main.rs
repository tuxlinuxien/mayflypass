use api::{database, server};

#[tokio::main]
async fn main() {
    let pool = database::create_pool("sqlite::memory:", 1).await.unwrap();
    database::run_migrations(&pool).await.unwrap();
    server::init("0.0.0.0:8080", pool).await;
}
