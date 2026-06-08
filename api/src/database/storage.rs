use super::error;

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct Storage {
    pub id: String,
    pub account_id: String,
    pub version: i64,
    pub deleted: bool,
    pub encrypted_dek: Vec<u8>,
    pub encrypted_payload: Vec<u8>,
}

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct StorageUpsert {
    pub id: String,
    pub version: i64,
    pub deleted: bool,
    pub encrypted_dek: Vec<u8>,
    pub encrypted_payload: Vec<u8>,
}

pub async fn get<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &str,
    id: &str,
) -> Result<Storage, error::Error> {
    let storage = sqlx::query_as::<_, Storage>(
        r#"
        SELECT id, account_id, version, deleted, encrypted_dek, encrypted_payload
        FROM storage
        WHERE id = ? AND account_id = ?
        "#,
    )
    .bind(&id)
    .bind(&account_id)
    .fetch_one(executor)
    .await?;
    Ok(storage)
}

pub async fn upsert<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &str,
    upsert: StorageUpsert,
) -> Result<Storage, error::Error> {
    let res = sqlx::query_as::<_, Storage>(
        r#"
        INSERT INTO storage (id, account_id, version, deleted, encrypted_dek, encrypted_payload)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(id)
        DO UPDATE SET
            version = excluded.version,
            deleted = excluded.deleted,
            encrypted_dek = excluded.encrypted_dek,
            encrypted_payload = excluded.encrypted_payload
        WHERE
            storage.account_id = excluded.account_id
            AND storage.version < excluded.version
        RETURNING id, account_id, version, deleted, encrypted_dek, encrypted_payload
        "#,
    )
    // values
    .bind(&upsert.id)
    .bind(&account_id)
    .bind(upsert.version)
    .bind(upsert.deleted)
    .bind(&upsert.encrypted_dek)
    .bind(&upsert.encrypted_payload)
    // where
    .bind(&account_id)
    .bind(&upsert.version)
    .fetch_one(executor)
    .await?;
    Ok(res)
}

#[cfg(test)]
mod test {
    use super::super::account;
    use super::*;
    const TEST_STORAGE_ID: &str = "test-storage-id";

    #[tokio::test]
    async fn test_upsert_insert() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first (foreign key constraint)
        let account = account::insert(
            &pool,
            account::AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        upsert(
            &pool,
            &account.id,
            StorageUpsert {
                id: TEST_STORAGE_ID.to_string(),
                version: 1,
                deleted: false,
                encrypted_dek: vec![1, 2, 3],
                encrypted_payload: vec![4, 5, 6],
            },
        )
        .await
        .unwrap();

        let result = get(&pool, &account.id, TEST_STORAGE_ID).await.unwrap();
        assert_eq!(result.id, TEST_STORAGE_ID.to_string());
        assert_eq!(result.account_id, account.id);
        assert_eq!(result.version, 1);
        assert_eq!(result.deleted, false);
        assert_eq!(result.encrypted_dek, vec![1, 2, 3]);
        assert_eq!(result.encrypted_payload, vec![4, 5, 6]);
    }

    #[tokio::test]
    async fn test_upsert_update_higher_version() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first (foreign key constraint)
        let account = account::insert(
            &pool,
            account::AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        // Insert initial version
        upsert(
            &pool,
            &account.id,
            StorageUpsert {
                id: TEST_STORAGE_ID.to_string(),
                version: 1,
                deleted: false,
                encrypted_dek: vec![1, 2, 3],
                encrypted_payload: vec![4, 5, 6],
            },
        )
        .await
        .unwrap();

        // Update with higher version
        upsert(
            &pool,
            &account.id,
            StorageUpsert {
                id: TEST_STORAGE_ID.to_string(),
                version: 2,
                deleted: true,
                encrypted_dek: vec![7, 8, 9],
                encrypted_payload: vec![10, 11, 12],
            },
        )
        .await
        .unwrap();

        let result = get(&pool, &account.id, TEST_STORAGE_ID).await.unwrap();
        assert_eq!(result.id, TEST_STORAGE_ID.to_string());
        assert_eq!(result.version, 2);
        assert_eq!(result.deleted, true);
        assert_eq!(result.encrypted_dek, vec![7, 8, 9]);
        assert_eq!(result.encrypted_payload, vec![10, 11, 12]);
    }

    #[tokio::test]
    async fn test_upsert_no_update_lower_version() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first (foreign key constraint)
        let account = account::insert(
            &pool,
            account::AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        let mut item = StorageUpsert {
            id: TEST_STORAGE_ID.to_string(),
            version: 2,
            deleted: false,
            encrypted_dek: vec![1, 2, 3],
            encrypted_payload: vec![4, 5, 6],
        };

        // Insert initial version
        upsert(&pool, &account.id, item.clone()).await.unwrap();

        // Try to update with same version - should not update
        let result = upsert(&pool, &account.id, item.clone()).await;
        assert!(result.is_err());

        // Try to update with lower version - should not update
        item.version = 1;
        let result = upsert(&pool, &account.id, item).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_upsert_update_wrong_user() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first (foreign key constraint)
        let account1 = account::insert(
            &pool,
            account::AccountInsert {
                email: "test1@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        let account2 = account::insert(
            &pool,
            account::AccountInsert {
                email: "test2@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        let mut item = StorageUpsert {
            id: TEST_STORAGE_ID.to_string(),
            version: 1,
            deleted: false,
            encrypted_dek: vec![1, 2, 3],
            encrypted_payload: vec![4, 5, 6],
        };

        // Insert initial version
        upsert(&pool, &account1.id, item.clone()).await.unwrap();

        // Bump the version to force the update
        item.version += 1;

        // Update with wrong user
        let res = upsert(&pool, &account2.id, item).await;
        assert!(res.is_err());
    }
}
