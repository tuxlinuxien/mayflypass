use chrono::{DateTime, Utc};
use sha2::Digest;

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct TokenResult {
    pub token_hash: String,
    pub account_id: String,
    pub valid_until: DateTime<Utc>,
}

pub async fn generate(pool: &sqlx::SqlitePool, account_id: &str) -> Result<String, sqlx::Error> {
    // generate random refresh token
    let token = uuid::Uuid::new_v4().to_string();
    // hash it so if the db is leaked we can't mint new tokens
    let mut hasher = sha2::Sha256::new();
    hasher.update(token.as_bytes());
    let hash = hasher.finalize();
    let token_hash: String = hex::encode(hash.to_vec());
    // store the token
    sqlx::query(
        r"
        INSERT INTO refresh_token (token_hash, account_id)
        VALUES (?, ?)
    ",
    )
    .bind(token_hash)
    .bind(account_id)
    .execute(pool)
    .await?;
    Ok(token)
}

pub async fn get(pool: &sqlx::SqlitePool, token: &str) -> Result<Option<TokenResult>, sqlx::Error> {
    // hash it so if the db is leaked we can't mint new tokens
    let mut hasher = sha2::Sha256::new();
    hasher.update(token.as_bytes());
    let hash = hasher.finalize();
    let token_hash: String = hex::encode(hash.to_vec());
    // store the token
    let res = sqlx::query_as::<_, TokenResult>(
        r"
        DELETE FROM refresh_token
        WHERE token_hash = ? AND valid_until > datetime('now')
        RETURNING token_hash, account_id, valid_until
    ",
    )
    .bind(token_hash)
    .fetch_optional(pool)
    .await?;
    Ok(res)
}

#[cfg(test)]
mod test {
    use super::super::account;
    use super::*;

    #[tokio::test]
    async fn test_generate_and_get() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        // create a dummy account since refresh tokens are bound to them
        let account = account::insert(
            &pool,
            account::AccountInsert {
                email: "test@email.com".into(),
                password: "12345678".into(),
            },
        )
        .await
        .unwrap();
        let refresh_token = generate(&pool, &account.id).await.unwrap();
        let refresh_token_info = get(&pool, &refresh_token).await.unwrap().unwrap();
        assert_eq!(&account.id, &refresh_token_info.account_id);
        assert!(get(&pool, &refresh_token).await.unwrap().is_none());
    }

    #[tokio::test]
    async fn test_get_expired() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        // create a dummy account since refresh tokens are bound to them
        let account = account::insert(
            &pool,
            account::AccountInsert {
                email: "test@email.com".into(),
                password: "12345678".into(),
            },
        )
        .await
        .unwrap();
        let refresh_token = generate(&pool, &account.id).await.unwrap();
        // set valid_until in the past
        sqlx::query(
            r"
            UPDATE refresh_token
            SET valid_until = (datetime('now', '-1 minute'))
            WHERE account_id = ?
        ",
        )
        .bind(account.id)
        .execute(&pool)
        .await
        .unwrap();
        // the token should be expired so no data are returned
        assert!(get(&pool, &refresh_token).await.unwrap().is_none());
    }
}
