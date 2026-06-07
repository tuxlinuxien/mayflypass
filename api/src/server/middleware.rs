use crate::database;
use crate::server::error::ApiError;
use crate::server::lib::token;
use crate::server::state::AppState;
use axum::extract::{Request, State};
use axum::http;
use axum::middleware::Next;
use axum::response::Response;

#[derive(Clone)]
pub struct AuthUserId(pub String);

pub async fn auth(
    State(state): State<AppState>,
    mut req: Request,
    next: Next,
) -> Result<Response, ApiError> {
    let bearer_token = req
        .headers()
        .get(http::header::AUTHORIZATION)
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.strip_prefix("Bearer "))
        .ok_or(ApiError::InvalidTokenError)?
        .to_owned();

    let claims = token::verify(&state.access_token_key, &bearer_token)?;
    let account = database::account::get_by_id(&state.pool, &claims.sub)
        .await?
        .ok_or(ApiError::InvalidTokenError)?;
    if account.password_updated_at > claims.iat {
        return Err(ApiError::InvalidTokenError);
    }
    req.extensions_mut().insert(AuthUserId(account.id));
    Ok(next.run(req).await)
}
