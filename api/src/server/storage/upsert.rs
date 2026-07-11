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
pub struct UpsertInput {
    id: Uuid,
    updated_at_ms: i64,
    deleted: bool,
    #[serde_as(as = "serde_with::hex::Hex")]
    encrypted_dek: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    encrypted_payload: Vec<u8>,
}

pub async fn upsert(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
    Json(payload): Json<UpsertInput>,
) -> Result<(), ApiError> {
    let input = database::storage::StorageUpsert {
        id: payload.id,
        updated_at_ms: payload.updated_at_ms,
        deleted: payload.deleted,
        encrypted_dek: payload.encrypted_dek,
        encrypted_payload: payload.encrypted_payload,
    };
    // do not return the result
    let _ = database::storage::upsert(&state.pool, &account_id, &input).await?;
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
        UpsertInput {
            id: test_storage_id(),
            updated_at_ms: 1,
            deleted: false,
            encrypted_dek: vec![1, 2, 3],
            encrypted_payload: vec![4, 5, 6],
        }
    }

    #[tokio::test]
    async fn test_upsert_insert_success() {
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
    async fn test_upsert_not_logged_in() {
        let (app, _pool) = testing::init_test_server().await;

        let input = create_test_input();
        let server = axum_test::TestServer::new(app);
        let response = server.post("/api/storage").json(&input).await;

        response.assert_status_unauthorized();
    }
}
