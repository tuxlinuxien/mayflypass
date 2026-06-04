pub mod account;
mod account_lib;
mod constants;

pub async fn create_pool(conn: &str, max_connections: u32) -> Result<sqlx::AnyPool, sqlx::Error> {
    sqlx::any::install_default_drivers();
    sqlx::any::AnyPoolOptions::new()
        .max_connections(max_connections)
        .connect(conn)
        .await
}

pub async fn run_migrations(pool: &sqlx::AnyPool) -> Result<(), sqlx::migrate::MigrateError> {
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
