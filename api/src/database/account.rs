use super::error;
use super::password;
use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct AccountInsert {
    pub username: String,
    pub password: Vec<u8>,
}

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct AccountResult {
    pub id: Uuid,
    pub username: String,
    pub password_hash: String,
    pub password_updated_at: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

impl AccountResult {
    pub async fn verify_password(&self, password: &[u8]) -> bool {
        password::verify_password(password, &self.password_hash).await
    }
}

pub async fn insert<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    insert: &AccountInsert,
) -> Result<AccountResult, error::Error> {
    let hash = super::password::hash_password(&insert.password).await;

    let res = sqlx::query_as::<_, AccountResult>(
        r"
        INSERT INTO account (id, username, password_hash)
        VALUES (?, ?, ?)
        RETURNING id, username, created_at, password_hash, password_updated_at
        ",
    )
    .bind(uuid::Uuid::now_v7())
    .bind(&insert.username)
    .bind(&hash)
    .fetch_one(executor)
    .await?;
    Ok(res)
}

pub async fn get_by_username<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    username: &str,
) -> Result<Option<AccountResult>, error::Error> {
    let res = sqlx::query_as::<_, AccountResult>(
        r"
        SELECT id, username, created_at, password_hash, password_updated_at
        FROM account
        WHERE username = ?
        ",
    )
    .bind(username)
    .fetch_optional(executor)
    .await?;
    Ok(res)
}

pub async fn get_by_id<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    id: &Uuid,
) -> Result<Option<AccountResult>, error::Error> {
    let res = sqlx::query_as::<_, AccountResult>(
        r"
        SELECT id, username, created_at, password_hash, password_updated_at
        FROM account
        WHERE id = ?
        ",
    )
    .bind(id)
    .fetch_optional(executor)
    .await?;
    Ok(res)
}

pub async fn update_password<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    id: &Uuid,
    new_password: &[u8],
) -> Result<(), error::Error> {
    let new_hash = super::password::hash_password(&new_password).await;
    sqlx::query_as::<_, AccountResult>(
        r"
        UPDATE account SET password_hash = ?, password_updated_at = (datetime('now'))
        WHERE id = ?
        ",
    )
    .bind(new_hash)
    .bind(id)
    .fetch_optional(executor)
    .await?;
    Ok(())
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
            &AccountInsert {
                username: "username".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        assert_eq!(result.username, "username");
        assert!(result.password_hash != "password");
        assert!(result.verify_password("password".as_bytes()).await);
    }

    #[tokio::test]
    async fn test_get_by_username() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let result = insert(
            &pool,
            &AccountInsert {
                username: "username".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        let account = get_by_username(&pool, &result.username).await.unwrap();
        assert!(account.is_some())
    }

    #[tokio::test]
    async fn test_get_by_id() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let account_insert = AccountInsert {
            username: "username".into(),
            password: "password".into(),
        };
        let result = insert(&pool, &account_insert).await.unwrap();
        let account = get_by_id(&pool, &result.id).await.unwrap();
        let account = account.unwrap();
        assert_eq!(account.username, account_insert.username);
    }

    #[tokio::test]
    async fn test_update_password() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let account_insert = AccountInsert {
            username: "username".into(),
            password: "password".into(),
        };
        let result = insert(&pool, &account_insert).await.unwrap();
        update_password(&pool, &result.id, "new_password".as_bytes())
            .await
            .unwrap();
        let account = get_by_id(&pool, &result.id).await.unwrap().unwrap();
        assert!(account.verify_password("new_password".as_bytes()).await == true);
    }
}
