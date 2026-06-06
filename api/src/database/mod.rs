pub mod account;
pub mod captchat;
mod constants;
mod password;

pub async fn create_pool(
    conn: &str,
    max_connections: u32,
) -> Result<sqlx::SqlitePool, sqlx::Error> {
    use std::str::FromStr;
    let opts = sqlx::sqlite::SqliteConnectOptions::from_str(conn)?
        .pragma("foreign_keys", "true")
        .create_if_missing(true);
    sqlx::sqlite::SqlitePoolOptions::new()
        .max_connections(max_connections)
        .connect_with(opts)
        .await
}

pub async fn run_migrations(pool: &sqlx::SqlitePool) -> Result<(), sqlx::migrate::MigrateError> {
    sqlx::migrate!("src/database/migrations/").run(pool).await
}

#[cfg(test)]
mod test {
    #[tokio::test]
    async fn test_migrations() {
        let pool = super::create_pool("sqlite::memory:", 1).await.unwrap();
        super::run_migrations(&pool).await.unwrap();
    }
}
