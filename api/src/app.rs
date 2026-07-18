use crate::database::challenge::DIFFICULTY;
use clap::Parser;
use tracing::level_filters::LevelFilter;

#[derive(Debug, Parser)]
#[command(version, about)]
pub struct App {
    #[arg(long, env, default_value = "0.0.0.0")]
    pub host_interface: String,

    #[arg(long, env, default_value = "8080")]
    pub host_port: u16,

    #[arg(long, env, default_value = "sqlite::memory:")]
    pub database_url: String,

    #[arg(long)]
    pub dev: bool,

    #[arg(long, env, default_value = "info")]
    pub verbosity: LevelFilter,

    #[arg(long, env, default_value = "easy")]
    pub challenge: DIFFICULTY,

    #[arg(long, env, default_value = "")]
    pub access_token_key: String,
}
