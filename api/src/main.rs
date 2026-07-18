use api::{app::App, database, server};
use clap::Parser;

#[tokio::main]
async fn main() {
    let args = App::parse();
    api::init_logger(args.verbosity);

    // create the database and start the migration
    let pool = database::create_pool(&args.database_url, 5).await.unwrap();
    database::run_migrations(&pool).await.unwrap();

    // launch the server
    let interface = format!("{}:{}", args.host_interface, args.host_port);
    tracing::info!("[challenge difficulty] {}", args.challenge);
    tracing::info!("[listen interface] {interface}");
    server::init(&interface, pool, args.dev, args.challenge).await;
}
