use super::password;
use chrono::{DateTime, Utc};
use sqlx::SqlitePool;

#[derive(Debug, Clone)]
pub struct AccountInsert {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct AccountResult {
    pub id: String,
    pub email: String,
    pub password_hash: String,
    pub password_updated_at: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

impl AccountResult {
    pub async fn verify_password(&self, password: &str) -> bool {
        password::verify_password(password, &self.password_hash).await
    }
}

pub async fn insert(
    pool: &SqlitePool,
    insert: AccountInsert,
) -> Result<AccountResult, sqlx::Error> {
    let hash = super::password::hash_password(&insert.password).await;
    sqlx::query_as::<_, AccountResult>(
        r"
        INSERT INTO account (id, email, password_hash)
        VALUES (?, ?, ?)
        RETURNING id, email, password_hash, password_updated_at, created_at
        ",
    )
    .bind(&uuid::Uuid::now_v7().to_string())
    .bind(&insert.email)
    .bind(&hash)
    .fetch_one(pool)
    .await
}

pub async fn get(pool: &SqlitePool, email: &str) -> Result<Option<AccountResult>, sqlx::Error> {
    sqlx::query_as::<_, AccountResult>(
        r"
        SELECT id, email, password_hash, password_updated_at, created_at
        FROM account 
        WHERE email = ? 
        ",
    )
    .bind(email)
    .fetch_optional(pool)
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
            AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        assert_eq!(result.email, "test@example.com");
        assert!(result.password_hash != "password");
        assert!(result.verify_password("password").await);
    }

    #[tokio::test]
    async fn test_get_account() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let result = insert(
            &pool,
            AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        let account = get(&pool, &result.email).await.unwrap();
        assert!(account.is_some())
    }
}
