use super::account_lib;
use super::constants;
use sqlx::AnyPool;

#[derive(Debug, Clone)]
pub struct InsertAccount {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct AccountResult {
    pub id: String,
    pub email: String,
    pub password_hash: String,
    pub password_secret: Vec<u8>,
    pub access_token_secret: Vec<u8>,
    pub refresh_token_secret: Vec<u8>,
    pub created_at: String,
}

impl AccountResult {
    pub async fn verify_password(&self, password: &str) -> bool {
        account_lib::verify_password(password, &self.password_hash, &self.password_secret).await
    }
}

pub async fn insert(pool: &AnyPool, insert: InsertAccount) -> Result<AccountResult, sqlx::Error> {
    let (password_hash, password_secret) =
        super::account_lib::hash_password(&insert.password).await;
    sqlx::query_as::<_, AccountResult>(
        r"
        INSERT INTO account (id, email, password_hash, password_secret, access_token_secret, refresh_token_secret, created_at)
        VALUES (?, ?, ?, ?, ?,?, CURRENT_TIMESTAMP)
        RETURNING id, email, password_hash, password_secret, access_token_secret, refresh_token_secret, created_at
        ",
    )
    .bind(&uuid::Uuid::now_v7().to_string())
    .bind(&insert.email)
    .bind(&password_hash)
    .bind(&password_secret)
    .bind(&super::account_lib::gen_bytes(constants::ACCESS_TOKEN_SECRET_LEN))
    .bind(&super::account_lib::gen_bytes(constants::REFRESH_TOKEN_SECRET_LEN))
    .fetch_one(pool)
    .await
}

#[cfg(test)]
mod test {
    use super::*;

    #[tokio::test]
    async fn test_insert_account() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let result = insert(
            &pool,
            InsertAccount {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        assert_eq!(result.email, "test@example.com");
        assert!(result.password_hash != "password");
        assert!(result.password_secret.len() == constants::PASSWORD_SECRET_LEN);
        assert!(result.access_token_secret.len() == constants::ACCESS_TOKEN_SECRET_LEN);
        assert!(result.refresh_token_secret.len() == constants::REFRESH_TOKEN_SECRET_LEN);
        assert!(result.verify_password("password").await);
    }
}
