use crate::server::error::ApiError;
use chrono::{DateTime, Duration, Utc};
use jsonwebtoken::{DecodingKey, EncodingKey, Validation};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct JwtClaim {
    pub sub: Uuid,
    #[serde(with = "chrono::serde::ts_seconds")]
    pub exp: DateTime<Utc>,
    #[serde(with = "chrono::serde::ts_seconds")]
    pub iat: DateTime<Utc>,
    pub id: Uuid, // adds some entropy
}

pub fn new(key: &[u8; 32], account_id: &Uuid, iat: DateTime<Utc>) -> anyhow::Result<String> {
    let claims = JwtClaim {
        sub: account_id.clone(),
        iat: iat.clone(),
        exp: iat + Duration::minutes(15),
        id: Uuid::now_v7(),
    };
    let header = jsonwebtoken::Header::new(jsonwebtoken::Algorithm::HS256);
    let key = EncodingKey::from_secret(&key.to_vec());
    let token = jsonwebtoken::encode(&header, &claims, &key)?;
    Ok(token.to_string())
}

pub fn verify(key: &[u8; 32], token: &str) -> Result<JwtClaim, ApiError> {
    let key = DecodingKey::from_secret(&key.to_vec());
    let claims = jsonwebtoken::decode::<JwtClaim>(token, &key, &Validation::default())
        .map_err(|_| ApiError::InvalidTokenError)?;
    Ok(claims.claims)
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::database;
    use crate::server::testing;
    use chrono::Duration;

    #[tokio::test]
    async fn test_access_token() {
        let (_, state) = testing::init_test_server().await;
        let account = database::account::insert(
            &state.pool,
            &database::account::AccountInsert {
                username: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let access_token = new(&key, &account.id, Utc::now()).unwrap();
        assert_eq!(account.id, verify(&key, &access_token).unwrap().sub);
    }

    #[tokio::test]
    async fn test_access_token_expired() {
        let (_, state) = testing::init_test_server().await;
        let account = database::account::insert(
            &state.pool,
            &database::account::AccountInsert {
                username: "test@mail.com".into(),
                password: "123456789".into(),
            },
        )
        .await
        .unwrap();
        let key = [0u8; 32];
        let past_iat = Utc::now() - Duration::days(1);
        let access_token = new(&key, &account.id, past_iat).unwrap();
        assert!(verify(&key, &access_token).is_err());
    }
}
