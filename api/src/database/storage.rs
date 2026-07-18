use super::error;
use uuid::Uuid;

#[derive(Debug, Clone, sqlx::FromRow, PartialEq)]
pub struct Storage {
    pub id: Uuid,
    pub account_id: Uuid,
    pub updated_at_ms: i64,
    pub deleted: bool,
    pub encrypted_dek: Vec<u8>,
    pub encrypted_payload: Vec<u8>,
}

#[derive(Debug, Clone, sqlx::FromRow)]
pub struct StorageUpsert {
    pub id: Uuid,
    pub updated_at_ms: i64,
    pub deleted: bool,
    pub encrypted_dek: Vec<u8>,
    pub encrypted_payload: Vec<u8>,
}

pub async fn get<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &Uuid,
    id: &Uuid,
) -> Result<Option<Storage>, error::Error> {
    let item = sqlx::query_as::<_, Storage>(
        r#"
        SELECT id, account_id, updated_at_ms, deleted, encrypted_dek, encrypted_payload
        FROM storage
        WHERE id = ? AND account_id = ?
        "#,
    )
    .bind(id)
    .bind(account_id)
    .fetch_optional(executor)
    .await?;
    Ok(item)
}

pub async fn select<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &Uuid,
) -> Result<Vec<Storage>, error::Error> {
    let items = sqlx::query_as::<_, Storage>(
        r#"
        SELECT id, account_id, updated_at_ms, deleted, encrypted_dek, encrypted_payload
        FROM storage
        WHERE account_id = ?
        "#,
    )
    .bind(account_id)
    .fetch_all(executor)
    .await?;
    Ok(items)
}

pub async fn upsert<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &Uuid,
    upsert: &StorageUpsert,
) -> Result<Option<Storage>, error::Error> {
    let mut upsert = upsert.clone();
    if upsert.deleted {
        upsert.encrypted_dek = vec![];
        upsert.encrypted_payload = vec![];
    }
    let res = sqlx::query_as::<_, Storage>(
        r#"
        INSERT INTO storage (id, account_id, updated_at_ms, deleted, encrypted_dek, encrypted_payload)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT (id, account_id)
        DO UPDATE SET
            updated_at_ms = excluded.updated_at_ms,
            deleted = excluded.deleted,
            encrypted_dek = excluded.encrypted_dek,
            encrypted_payload = excluded.encrypted_payload
        WHERE
            storage.updated_at_ms < excluded.updated_at_ms
        RETURNING id, account_id, updated_at_ms, deleted, encrypted_dek, encrypted_payload
        "#,
    )
    // values
    .bind(upsert.id)
    .bind(account_id)
    .bind(upsert.updated_at_ms)
    .bind(upsert.deleted)
    .bind(upsert.encrypted_dek)
    .bind(upsert.encrypted_payload)
    // where
    .bind(account_id)
    .bind(upsert.updated_at_ms)
    .fetch_optional(executor)
    .await?;
    Ok(res)
}

pub async fn delete_all<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    account_id: &Uuid,
) -> Result<(), error::Error> {
    sqlx::query(r#"DELETE FROM storage WHERE account_id = ?"#)
        .bind(account_id)
        .execute(executor)
        .await?;
    Ok(())
}

#[cfg(test)]
mod test {
    use super::super::account;
    use super::*;
    fn test_storage_id() -> Uuid {
        uuid::Uuid::from_u128(12345678901234567890123456789012)
    }

    #[tokio::test]
    async fn test_upsert_insert() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first
        let account = account::insert(
            &pool,
            &account::AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        upsert(
            &pool,
            &account.id,
            &StorageUpsert {
                id: test_storage_id(),
                updated_at_ms: 1,
                deleted: false,
                encrypted_dek: vec![1, 2, 3],
                encrypted_payload: vec![4, 5, 6],
            },
        )
        .await
        .unwrap();

        let result = get(&pool, &account.id, &test_storage_id())
            .await
            .unwrap()
            .unwrap();
        assert_eq!(result.id, test_storage_id());
        assert_eq!(result.account_id, account.id);
        assert_eq!(result.updated_at_ms, 1);
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

        // Create an account first
        let account = account::insert(
            &pool,
            &account::AccountInsert {
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
            &StorageUpsert {
                id: test_storage_id(),
                updated_at_ms: 1,
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
            &StorageUpsert {
                id: test_storage_id(),
                updated_at_ms: 2,
                deleted: false,
                encrypted_dek: vec![7, 8, 9],
                encrypted_payload: vec![10, 11, 12],
            },
        )
        .await
        .unwrap();

        let result = get(&pool, &account.id, &test_storage_id())
            .await
            .unwrap()
            .unwrap();
        assert_eq!(result.id, test_storage_id());
        assert_eq!(result.updated_at_ms, 2);
        assert_eq!(result.deleted, false);
        assert_eq!(result.encrypted_dek, vec![7, 8, 9]);
        assert_eq!(result.encrypted_payload, vec![10, 11, 12]);

        // Update with higher version (deleted)
        upsert(
            &pool,
            &account.id,
            &StorageUpsert {
                id: test_storage_id(),
                updated_at_ms: 3,
                deleted: true,
                encrypted_dek: vec![7, 8, 9],
                encrypted_payload: vec![10, 11, 12],
            },
        )
        .await
        .unwrap();

        let result = get(&pool, &account.id, &test_storage_id())
            .await
            .unwrap()
            .unwrap();
        assert_eq!(result.id, test_storage_id());
        assert_eq!(result.updated_at_ms, 3);
        assert_eq!(result.deleted, true);
        assert_eq!(result.encrypted_dek.len(), 0);
        assert_eq!(result.encrypted_payload.len(), 0);
    }

    #[tokio::test]
    async fn test_upsert_no_update_lower_version() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first
        let account = account::insert(
            &pool,
            &account::AccountInsert {
                email: "test@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        let mut item = StorageUpsert {
            id: test_storage_id(),
            updated_at_ms: 2,
            deleted: false,
            encrypted_dek: vec![1, 2, 3],
            encrypted_payload: vec![4, 5, 6],
        };

        // Insert initial updated_at_ms
        upsert(&pool, &account.id, &item).await.unwrap();

        // Try to update with same updated_at_ms and should not update
        let result = upsert(&pool, &account.id, &item).await;
        assert!(result.unwrap().is_none());

        // Try to update with lower updated_at_ms and should not update
        item.updated_at_ms = 1;
        let result = upsert(&pool, &account.id, &item).await;
        assert!(result.unwrap().is_none());
    }

    #[tokio::test]
    async fn test_select() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first
        let account1 = account::insert(
            &pool,
            &account::AccountInsert {
                email: "test1@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        let item1_id = uuid::Uuid::from_u128(11111111111111111111111111111111);
        let item2_id = uuid::Uuid::from_u128(22222222222222222222222222222222);
        let item1 = StorageUpsert {
            id: item1_id,
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![1, 1, 1],
            encrypted_payload: vec![2, 2, 2],
        };
        let item2 = StorageUpsert {
            id: item2_id,
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![3, 3, 3],
            encrypted_payload: vec![4, 4, 4],
        };

        let ret1 = upsert(&pool, &account1.id, &item1).await.unwrap().unwrap();
        let ret2 = upsert(&pool, &account1.id, &item2).await.unwrap().unwrap();
        let result = select(&pool, &account1.id).await.unwrap();
        assert_eq!(2, result.len());
        assert!(result.iter().find(|i| ret1.eq(i)).is_some());
        assert!(result.iter().find(|i| ret2.eq(i)).is_some());

        // Test with an account that doesn't have any items
        let account2 = account::insert(
            &pool,
            &account::AccountInsert {
                email: "test2@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();
        let result = select(&pool, &account2.id).await.unwrap();
        assert_eq!(0, result.len());
    }

    #[tokio::test]
    async fn test_delete_all() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();

        // Create an account first
        let account1 = account::insert(
            &pool,
            &account::AccountInsert {
                email: "test1@example.com".into(),
                password: "password".into(),
            },
        )
        .await
        .unwrap();

        let item1_id = uuid::Uuid::from_u128(11111111111111111111111111111111);
        let item2_id = uuid::Uuid::from_u128(22222222222222222222222222222222);
        let item1 = StorageUpsert {
            id: item1_id,
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![1, 1, 1],
            encrypted_payload: vec![2, 2, 2],
        };
        let item2 = StorageUpsert {
            id: item2_id,
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![3, 3, 3],
            encrypted_payload: vec![4, 4, 4],
        };

        let _ = upsert(&pool, &account1.id, &item1).await.unwrap().unwrap();
        let _ = upsert(&pool, &account1.id, &item2).await.unwrap().unwrap();
        let result = select(&pool, &account1.id).await.unwrap();
        assert_eq!(2, result.len());
        assert!(delete_all(&pool, &account1.id).await.is_ok());
        let result = select(&pool, &account1.id).await.unwrap();
        assert_eq!(0, result.len());
    }
}
