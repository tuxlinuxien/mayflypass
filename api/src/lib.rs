pub mod app;
pub mod constants;
pub mod database;
pub mod server;

pub fn init_logger(level: tracing::level_filters::LevelFilter) {
    let filter = tracing_subscriber::EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new(format!("api={}", level)));
    tracing_subscriber::fmt().with_env_filter(filter).init();
}
