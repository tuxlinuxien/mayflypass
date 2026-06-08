use super::error;
use super::password;
use crate::constants;
use chrono::{DateTime, Utc};

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
    pub kek_m_cost: u32,
    pub kek_t_cost: u32,
    pub kek_p_cost: u32,
    pub kek_output_len: u32,
    pub kek_salt: Vec<u8>,
}

impl AccountResult {
    pub async fn verify_password(&self, password: &str) -> bool {
        password::verify_password(password, &self.password_hash).await
    }
}

pub async fn insert<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    insert: AccountInsert,
) -> Result<AccountResult, error::Error> {
    let hash = super::password::hash_password(&insert.password).await;

    let res = sqlx::query_as::<_, AccountResult>(
        r"
        INSERT INTO account (id, email, password_hash, kek_m_cost, kek_t_cost, kek_p_cost, kek_output_len, kek_salt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        RETURNING id, email, password_hash, password_updated_at, created_at, kek_m_cost, kek_t_cost, kek_p_cost, kek_output_len, kek_salt
        ",
    )
    .bind(&uuid::Uuid::now_v7().to_string())
    .bind(&insert.email)
    .bind(&hash)
    .bind(&constants::KEK_M_COST)
    .bind(&constants::KEK_T_COST)
    .bind(&constants::KEK_P_COST)
    .bind(&constants::KEK_OUTPUT_LEN)
    .bind(super::password::gen_bytes( constants::KEK_SALT_LEN))
    .fetch_one(executor)
    .await?;
    Ok(res)
}

pub async fn get_by_email<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    email: &str,
) -> Result<Option<AccountResult>, error::Error> {
    let res = sqlx::query_as::<_, AccountResult>(
        r"
        SELECT id, email, password_hash, password_updated_at, created_at, kek_m_cost, kek_t_cost, kek_p_cost, kek_output_len, kek_salt
        FROM account
        WHERE email = ?
        ",
    )
    .bind(email)
    .fetch_optional(executor)
    .await?;
    Ok(res)
}

pub async fn get_by_id<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    id: &str,
) -> Result<Option<AccountResult>, error::Error> {
    let res = sqlx::query_as::<_, AccountResult>(
        r"
        SELECT id, email, password_hash, password_updated_at, created_at, kek_m_cost, kek_t_cost, kek_p_cost, kek_output_len, kek_salt
        FROM account
        WHERE id = ?
        ",
    )
    .bind(id)
    .fetch_optional(executor)
    .await?;
    Ok(res)
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
    async fn test_get_by_email() {
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
        let account = get_by_email(&pool, &result.email).await.unwrap();
        assert!(account.is_some())
    }

    #[tokio::test]
    async fn test_get_by_id() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let account_insert = AccountInsert {
            email: "test@example.com".into(),
            password: "password".into(),
        };
        let result = insert(&pool, account_insert.clone()).await.unwrap();
        let account = get_by_id(&pool, &result.id).await.unwrap();
        let account = account.unwrap();
        assert_eq!(account.email, account_insert.email);
        assert_eq!(account.kek_m_cost, constants::KEK_M_COST);
        assert_eq!(account.kek_t_cost, constants::KEK_T_COST);
        assert_eq!(account.kek_p_cost, constants::KEK_P_COST);
        assert_eq!(account.kek_output_len, constants::KEK_OUTPUT_LEN);
        assert_eq!(account.kek_salt.len(), constants::KEK_SALT_LEN);
    }
}
