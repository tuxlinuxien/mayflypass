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
    #[serde_as(as = "serde_with::hex::Hex")]
    old_password: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    new_password: Vec<u8>,
    storage_items: Vec<UpsertItem>,
}

impl UpdatePasswordInput {
    fn validate(&self) -> Result<(), ApiError> {
        let errors: Vec<FieldError> = vec![
            FieldError::check_required("old_password", &self.old_password),
            FieldError::check_required("new_password", &self.new_password),
        ]
        .into_iter()
        .flatten()
        .collect();
        if errors.is_empty() {
            return Ok(());
        }
        return Err(ApiError::BadRequestFieldErrors(errors));
    }
}

pub async fn update_password(
    State(state): State<AppState>,
    Extension(AuthUserId(account_id)): Extension<AuthUserId>,
    Json(payload): Json<UpdatePasswordInput>,
) -> Result<impl IntoResponse, ApiError> {
    // check the input
    payload.validate()?;

    let account = database::account::get_by_id(&state.pool, &account_id)
        .await?
        .ok_or(ApiError::UnauthorizedError)?;
    // check the the old password is valid before updating to the new_password
    if account.verify_password(&payload.old_password).await != true {
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

    let main_tx = async move {
        // remove all storage entries for the account.
        if let Err(e) = database::storage::delete_all(tx.as_mut(), &account.id).await {
            return (tx, Err(ApiError::InternalError(e.into())));
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
                return (tx, Err(ApiError::InternalError(e.into())));
            }
        }
        // update password
        if let Err(e) =
            database::account::update_password(tx.as_mut(), &account.id, &payload.new_password)
                .await
        {
            return (tx, Err(ApiError::InternalError(e.into())));
        }
        // remove all tokens.
        if let Err(e) = database::token::delete_all(tx.as_mut(), &account.id).await {
            return (tx, Err(ApiError::InternalError(e.into())));
        }
        return (tx, Ok(()));
    };

    let (tx, result) = main_tx.await;
    match &result {
        Ok(()) => {
            tx.commit()
                .await
                .map_err(|e| ApiError::InternalError(e.into()))?;
        }
        Err(_) => {
            tx.rollback()
                .await
                .map_err(|e| ApiError::InternalError(e.into()))?;
        }
    }
    return result;
}

#[cfg(test)]
mod test {
    use crate::server::{error::FieldError, testing};
    use serde_json::json;

    #[tokio::test]
    async fn test_update_password_missing_fields() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        let response = server
            .post("/api/account/password")
            .json(&json!({"old_password": "", "new_password": "", "storage_items": []}))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                FieldError::ValueRequired("old_password".into()),
                FieldError::ValueRequired("new_password".into())
            ]}),
        );
    }

    #[tokio::test]
    async fn test_update_password_invalid_old_password() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        let response = server
            .post("/api/account/password")
            .json(&json!({"old_password": &hex::encode([1u8].repeat(32)) , "new_password": &hex::encode([1u8].repeat(32)), "storage_items": []}))
            .await;
        response.assert_status_bad_request();
        let body = response.json::<serde_json::Value>();
        assert_eq!(
            body,
            serde_json::json!({"errors": [
                FieldError::CredentialsInvalid("old_password".into()),
            ]}),
        );
    }

    #[tokio::test]
    async fn test_update_password() {
        let (app, state) = testing::init_test_server().await;
        let account = testing::build_default_account(&state.pool).await;
        let server = testing::build_user_server(&account, &app).await;

        let response = server
            .post("/api/account/password")
            .json(&json!({"old_password": &hex::encode([0u8].repeat(32)) , "new_password": &hex::encode([1u8].repeat(32)), "storage_items": []}))
            .await;
        response.assert_status_ok();
        // user should be logged out
        let response = server.get("/api/account/info").await;
        response.assert_status_unauthorized();
        let value = sqlx::query_as::<_, (i64,)>(
            r#"SELECT count(*) FROM refresh_token WHERE account_id = ?"#,
        )
        .bind(account.id)
        .fetch_one(&state.pool)
        .await
        .unwrap();
        assert!(value.0 == 0);

        let response = server
            .post("/api/login")
            .json(
                &json!({"username": account.username, "password":  &hex::encode([1u8].repeat(32))}),
            )
            .await;
        response.assert_status_ok();
    }
}
