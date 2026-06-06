use crate::database;

use super::error::ApiError;
use super::state::AppState;
use axum::Json;
use axum::extract::State;

fn trimmed<'de, D: serde::Deserializer<'de>>(d: D) -> Result<String, D::Error> {
    use serde::Deserialize;
    Ok(String::deserialize(d)?.trim().to_string())
}

#[derive(Debug, serde::Deserialize)]
pub struct RegisterInput {
    #[serde(default, deserialize_with = "trimmed")]
    pub email: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub password: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub password_repeat: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub c_id: String,
    #[serde(default, deserialize_with = "trimmed")]
    pub c_code: String,
}

pub async fn register(
    State(state): State<AppState>,
    Json(mut payload): Json<RegisterInput>,
) -> Result<(), ApiError> {
    // normalize email
    payload.email = payload.email.to_lowercase();
    if payload.password.len() < 8 {
        return Err(ApiError::InvalidField {
            field: "password".into(),
            message: "must be at least 8 char long".into(),
        });
    }
    // check the password has a minimum length
    if payload.password != payload.password_repeat {
        return Err(ApiError::InvalidField {
            field: "password".into(),
            message: "mismatch".into(),
        });
    }

    // check the captchat is valid
    let is_valid = database::captchat::verify(&state.pool, &payload.c_id, &payload.c_code).await?;
    if !is_valid {
        return Err(ApiError::InvalidField {
            field: "code".into(),
            message: "invalid".into(),
        });
    }

    // insert account into the database
    let res = database::account::insert(
        &state.pool,
        database::account::AccountInsert {
            email: payload.email.clone(),
            password: payload.password.clone(),
        },
    )
    .await;
    match res {
        Ok(_) => {}
        Err(e) => match e {
            sqlx::Error::Database(db_err)
                if db_err.kind() == sqlx::error::ErrorKind::UniqueViolation =>
            {
                tracing::error!("email {} already exists", payload.email);
                return Err(ApiError::InvalidField {
                    field: "email".into(),
                    message: "duplicated".into(),
                });
            }
            _ => {
                tracing::error!("database error: {e}");
                return Err(ApiError::InternalError);
            }
        },
    }
    println!("{:?}", payload);
    Ok(())
}
