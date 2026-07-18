use axum::{Extension, extract::State, response::IntoResponse};
use serde::{Deserialize, Serialize};
use serde_with::serde_as;
use uuid::Uuid;

use crate::{
    database,
    server::{
        error::{ApiError, FieldError},
        json::Json,
        middleware::AuthUserId,
        state::AppState,
    },
};

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

#[serde_as]
#[derive(Debug, Deserialize)]
pub struct UpdatePasswordInput {
    old_password: String,
    new_password: String,
    storage_items: Vec<UpsertItem>,
}

pub async fn update_password(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
    Json(payload): Json<UpdatePasswordInput>,
) -> Result<impl IntoResponse, ApiError> {
    let account = database::account::get_by_id(&state.pool, &account_id)
        .await?
        .ok_or(ApiError::UnauthorizedError)?;
    // check the the old password is valid before updating to the new_password
    if account
        .verify_password(payload.old_password.as_bytes())
        .await
        != true
    {
        return Err(ApiError::BadRequestFieldErrors(vec![
            FieldError::CredentialsInvalid("old_password".into()),
        ]));
    }

    // in a transaction, we delete all the storage rows for a given account,
    // insert storage items then update the password.
    // finally, we force all sessions to be invalided by removing all tokens
    let mut tx = state
        .pool
        .begin()
        .await
        .map_err(|e| ApiError::InternalError(e.into()))?;

    // remove all storage entries for the account.
    if let Err(e) = database::storage::delete_all(tx.as_mut(), &account.id).await {
        let _ = tx.rollback().await;
        return Err(ApiError::InternalError(e.into()));
    }
    // insert storage items
    for item in payload.storage_items {
        let result = database::storage::upsert(
            tx.as_mut(),
            &account.id,
            &database::storage::StorageUpsert {
                id: item.id,
                updated_at_ms: item.updated_at_ms,
                deleted: item.deleted,
                encrypted_dek: item.encrypted_dek,
                encrypted_payload: item.encrypted_payload,
            },
        )
        .await;
        if let Err(e) = result {
            let _ = tx.rollback().await;
            return Err(ApiError::InternalError(e.into()));
        }
    }
    // update password
    if let Err(e) =
        database::account::update_password(tx.as_mut(), &account.id, &payload.new_password).await
    {
        let _ = tx.rollback().await;
        return Err(ApiError::InternalError(e.into()));
    }
    // remove all tokens.
    if let Err(e) = database::token::delete_all(tx.as_mut(), &account.id).await {
        let _ = tx.rollback().await;
        return Err(ApiError::InternalError(e.into()));
    }

    tx.commit()
        .await
        .map_err(|e| ApiError::InternalError(e.into()))?;
    // after that, the user should be forced to login again
    Ok(())
}
