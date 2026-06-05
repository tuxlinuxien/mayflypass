use api::server;

#[tokio::main]
async fn main() {
    server::init("0.0.0.0:8080").await;
}
