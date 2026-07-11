use crate::{
    database,
    server::{error::ApiError, json::Json, middleware::AuthUserId, state::AppState},
};
use axum::{Extension, extract::State};
use serde::{Deserialize, Serialize};
use serde_with::serde_as;
use uuid::Uuid;

#[serde_as]
#[derive(Debug, Serialize, Deserialize)]
pub struct UpsertItem {
    id: Uuid,
    updated_at_ms: i64,
    deleted: bool,
    #[serde_as(as = "serde_with::hex::Hex")]
    encrypted_dek: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    encrypted_payload: Vec<u8>,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(untagged)]
pub enum UpsertInput {
    One(UpsertItem),
    Many(Vec<UpsertItem>),
}

impl From<UpsertItem> for database::storage::StorageUpsert {
    fn from(value: UpsertItem) -> Self {
        Self {
            id: value.id,
            updated_at_ms: value.updated_at_ms,
            deleted: value.deleted,
            encrypted_dek: value.encrypted_dek,
            encrypted_payload: value.encrypted_payload,
        }
    }
}

pub async fn upsert(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
    Json(payload): Json<UpsertInput>,
) -> Result<(), ApiError> {
    // move all the UpsertInput values into a list of UpsertItem so we can
    // use a single method to process them later
    let items: Vec<database::storage::StorageUpsert> = match payload {
        UpsertInput::One(item) => vec![item.into()],
        UpsertInput::Many(items) => items.into_iter().map(|item| item.into()).collect(),
    };
    // upsert all the rows with a transaction
    let mut tx = state
        .pool
        .begin()
        .await
        .map_err(|e| ApiError::InternalError(e.into()))?;
    for item in &items {
        // if a single error is found, stop the processing now an return the error to the client
        if let Err(err) = database::storage::upsert(tx.as_mut(), &account_id, item.into()).await {
            tx.rollback()
                .await
                .map_err(|e| ApiError::InternalError(e.into()))?;
            return Err(err)?;
        }
    }
    // commit all the changes
    tx.commit()
        .await
        .map_err(|e| ApiError::InternalError(e.into()))?;
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::{database::storage, server::testing};

    fn test_storage_id() -> Uuid {
        uuid::Uuid::from_u128(12345678901234567890123456789012)
    }

    fn create_test_input() -> UpsertInput {
        UpsertInput::One(UpsertItem {
            id: test_storage_id(),
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![1, 2, 3],
            encrypted_payload: vec![4, 5, 6],
        })
    }

    #[tokio::test]
    async fn test_upsert_insert_single_item_success() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        // first insert
        let input = create_test_input();
        let response = server.post("/api/storage").json(&input).await;
        response.assert_status_ok();

        assert!(
            storage::select(&state.pool, &account.id)
                .await
                .unwrap()
                .len()
                == 1
        );

        // insert it again
        let response = server.post("/api/storage").json(&input).await;
        response.assert_status_ok();
        assert!(
            storage::select(&state.pool, &account.id)
                .await
                .unwrap()
                .len()
                == 1
        )
    }

    #[tokio::test]
    async fn test_upsert_insert_multiple_item_success() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        // send the same item multiple times
        let input = vec![create_test_input(), create_test_input()];
        let response = server.post("/api/storage").json(&input).await;
        response.assert_status_ok();

        assert!(
            storage::select(&state.pool, &account.id)
                .await
                .unwrap()
                .len()
                == 1
        );

        // insert it again
        let response = server.post("/api/storage").json(&input).await;
        response.assert_status_ok();
        assert!(
            storage::select(&state.pool, &account.id)
                .await
                .unwrap()
                .len()
                == 1
        )
    }

    #[tokio::test]
    async fn test_upsert_not_logged_in() {
        let (app, _pool) = testing::init_test_server().await;

        let input = create_test_input();
        let server = axum_test::TestServer::new(app);
        let response = server.post("/api/storage").json(&input).await;

        response.assert_status_unauthorized();
    }
}
