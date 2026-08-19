use crate::server::json::Json;
use crate::{
    database,
    server::{error::ApiError, middleware::AuthUserId, state::AppState},
};
use axum::{Extension, extract::State};
use serde::{Deserialize, Serialize};
use serde_with::serde_as;
use utoipa::ToSchema;
use uuid::Uuid;

#[serde_as]
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct SelectResponse {
    pub id: Uuid,
    pub updated_at_ms: i64,
    pub deleted: bool,
    #[schema(pattern = r"^[0-9a-fA-F]+$")]
    #[serde_as(as = "serde_with::hex::Hex")]
    pub encrypted_dek: Vec<u8>,
    #[schema(pattern = r"^[0-9a-fA-F]+$")]
    #[serde_as(as = "serde_with::hex::Hex")]
    pub encrypted_payload: Vec<u8>,
}

#[utoipa::path(
    get,
    path = "/api/storage",
    responses(
        (status = 200, description = "Storage items", body = Vec<SelectResponse>),
        (status = 401, description = "Unauthorized"),
        (status = 500, description = "Internal server error")
    )
)]
pub async fn select(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
) -> Result<Json<Vec<SelectResponse>>, ApiError> {
    let results = database::storage::select(&state.pool, &account_id).await?;
    let results = results
        .into_iter()
        .map(|result| SelectResponse {
            id: result.id,
            updated_at_ms: result.updated_at_ms,
            deleted: result.deleted,
            encrypted_dek: result.encrypted_dek,
            encrypted_payload: result.encrypted_payload,
        })
        .collect();
    Ok(Json(results))
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::{database::storage, server::testing};

    #[tokio::test]
    async fn test_select_no_items() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        let response = server.get("/api/storage").await;
        response.assert_status_ok();
        let results: Vec<SelectResponse> = response.json();
        assert_eq!(0, results.len());
    }

    #[tokio::test]
    async fn test_select_all_items() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        database::storage::upsert(
            &state.pool,
            &account.id,
            &storage::StorageUpsert {
                id: uuid::Uuid::now_v7(),
                updated_at_ms: 1,
                deleted: false,
                encrypted_dek: vec![1, 2, 3],
                encrypted_payload: vec![4, 5, 6],
            },
        )
        .await
        .unwrap();
        database::storage::upsert(
            &state.pool,
            &account.id,
            &storage::StorageUpsert {
                id: uuid::Uuid::now_v7(),
                updated_at_ms: 1,
                deleted: false,
                encrypted_dek: vec![1, 2, 3],
                encrypted_payload: vec![4, 5, 6],
            },
        )
        .await
        .unwrap();

        let response = server.get("/api/storage").await;
        response.assert_status_ok();
        let results: Vec<SelectResponse> = response.json();
        assert_eq!(2, results.len());

        for result in &results {
            assert_eq!(1, result.updated_at_ms);
            assert_eq!(false, result.deleted);
            assert_eq!(vec![1, 2, 3], result.encrypted_dek);
            assert_eq!(vec![4, 5, 6], result.encrypted_payload);
        }
    }
}
