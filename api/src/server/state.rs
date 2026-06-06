#[derive(Clone)]
pub struct AppState {
    pub pool: sqlx::SqlitePool,
    pub access_token_key: [u8; 32],
    pub refresh_token_key: [u8; 32],
}
