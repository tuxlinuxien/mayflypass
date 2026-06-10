use clap::Parser;
use tracing::level_filters::LevelFilter;

#[derive(Debug, Parser)]
#[command(version, about)]
pub struct App {
    #[arg(long, default_value = "0.0.0.0")]
    pub host_interface: String,

    #[arg(long, default_value = "8080")]
    pub host_port: u16,

    #[arg(long, default_value = "sqlite::memory:")]
    pub database_url: String,

    #[arg(long)]
    pub dev: bool,

    #[arg(long, default_value = "info")]
    pub verbosity: LevelFilter,
}
