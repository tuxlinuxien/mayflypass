use std::{fmt::Display, str::FromStr};

use serde::{Deserialize, Serialize};
use serde_with::serde_as;
use sha2::{Digest, Sha256};

use crate::database::password::gen_bytes;

#[derive(Debug, Clone, Copy)]
pub enum DIFFICULTY {
    NONE,
    EASY,
    MEDIUM,
    HARD,
}

impl DIFFICULTY {
    pub fn to_bytes(&self) -> [u8; 32] {
        match self {
            DIFFICULTY::NONE => [
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff,
            ],
            DIFFICULTY::EASY => [
                0x00, 0x00, 0x08, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff,
            ],
            DIFFICULTY::MEDIUM => [
                0x00, 0x00, 0x0f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff,
            ],
            DIFFICULTY::HARD => [
                0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                0xff, 0xff, 0xff, 0xff,
            ],
        }
    }
}

impl FromStr for DIFFICULTY {
    type Err = &'static str;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match &*s.to_lowercase() {
            "none" => Ok(DIFFICULTY::NONE),
            "easy" => Ok(DIFFICULTY::EASY),
            "medium" => Ok(DIFFICULTY::MEDIUM),
            "hard" => Ok(DIFFICULTY::HARD),
            _ => Err("invalid difficulty level, should be either none, easy, medium or hard"),
        }
    }
}

impl Display for DIFFICULTY {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            DIFFICULTY::NONE => f.write_str("none"),
            DIFFICULTY::EASY => f.write_str("easy"),
            DIFFICULTY::MEDIUM => f.write_str("medium"),
            DIFFICULTY::HARD => f.write_str("hard"),
        }
    }
}

#[serde_as]
#[derive(Debug, Clone, sqlx::FromRow, Serialize, Deserialize)]
pub struct ChallengeResult {
    #[serde_as(as = "serde_with::hex::Hex")]
    pub key: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub salt: Vec<u8>,
    #[serde_as(as = "serde_with::hex::Hex")]
    pub difficulty: Vec<u8>,
}

pub async fn generate<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    difficulty: DIFFICULTY,
) -> anyhow::Result<ChallengeResult> {
    let result = sqlx::query_as::<_, ChallengeResult>(
        r"
        INSERT INTO challenge (key, salt, difficulty)
        VALUES (?, ?, ?)
        RETURNING key, salt, difficulty
        ",
    )
    .bind(gen_bytes(32))
    .bind(gen_bytes(16))
    .bind(difficulty.to_bytes().to_vec())
    .fetch_one(executor)
    .await?;
    Ok(result)
}

pub async fn verify<'c, E: super::SqliteExecutor<'c>>(
    executor: E,
    key: &Vec<u8>,
    nonce: u64,
) -> anyhow::Result<bool> {
    let result = sqlx::query_as::<_, ChallengeResult>(
        r"
        DELETE FROM challenge WHERE key = ? AND valid_until > datetime('now')
        RETURNING key, salt, difficulty
        ",
    )
    .bind(key)
    .fetch_optional(executor)
    .await?;
    let challenge = match result {
        Some(result) => result,
        None => return Ok(false),
    };
    let nonce_bytes = nonce.to_le_bytes();

    let mut hasher = Sha256::new();
    hasher.update(&challenge.key);
    hasher.update(&challenge.salt);
    hasher.update(&nonce_bytes);
    let hash_result = hasher.finalize();

    Ok(hash_result.as_slice() < challenge.difficulty.as_slice())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::database::create_pool;

    const KEY_LEN: usize = 32;
    const SALT_LEN: usize = 16;
    const DIFFICULTY_LEN: usize = 32;

    async fn setup_test_db() -> sqlx::SqlitePool {
        let pool = create_pool("sqlite::memory:", 1).await.unwrap();
        crate::database::run_migrations(&pool).await.unwrap();
        pool
    }

    /// Solves the proof-of-work challenge by finding a nonce such that
    /// sha256(key + salt + nonce) < difficulty.
    /// This is a brute-force search starting from nonce = 0.
    fn solve_pow(challenge: &ChallengeResult) -> Option<u64> {
        use std::time::Instant;

        let start = Instant::now();
        for nonce in 0u64..=u64::MAX {
            let nonce_bytes = nonce.to_le_bytes();

            let mut hasher = Sha256::new();
            hasher.update(&challenge.key);
            hasher.update(&challenge.salt);
            hasher.update(&nonce_bytes);
            let hash_result = hasher.finalize();

            if hash_result.as_slice() < challenge.difficulty.as_slice() {
                let duration = start.elapsed();
                tracing::warn!("POW solved in {:?} (nonce: {})", duration, nonce);
                return Some(nonce);
            }
        }
        None
    }

    fn assert_byte_lengths(result: &ChallengeResult) {
        assert_eq!(
            result.key.len(),
            KEY_LEN,
            "key should be {} bytes, got {}",
            KEY_LEN,
            result.key.len()
        );
        assert_eq!(
            result.salt.len(),
            SALT_LEN,
            "salt should be {} bytes, got {}",
            SALT_LEN,
            result.salt.len()
        );
        assert_eq!(
            result.difficulty.len(),
            DIFFICULTY_LEN,
            "difficulty should be {} bytes, got {}",
            DIFFICULTY_LEN,
            result.difficulty.len()
        );
    }

    fn assert_difficulty_bytes(difficulty: &DIFFICULTY, result: &ChallengeResult) {
        let expected = difficulty.to_bytes();
        assert_eq!(
            &result.difficulty.as_slice()[..],
            &expected[..],
            "difficulty bytes should match the DIFFICULTY enum value"
        );
    }

    #[tokio::test]
    async fn test_generate_all_difficulties() {
        let pool = setup_test_db().await;
        for difficulty in [
            DIFFICULTY::NONE,
            DIFFICULTY::EASY,
            DIFFICULTY::MEDIUM,
            DIFFICULTY::HARD,
        ] {
            let result = generate(&pool, difficulty.clone()).await.unwrap();

            assert_byte_lengths(&result);
            assert_difficulty_bytes(&difficulty.clone(), &result);
        }
    }

    #[tokio::test]
    async fn test_generate_unique_keys() {
        let pool = setup_test_db().await;

        let result1 = generate(&pool, DIFFICULTY::EASY).await.unwrap();
        let result2 = generate(&pool, DIFFICULTY::EASY).await.unwrap();

        assert_ne!(result1.key, result2.key, "generated keys should be unique");
    }

    #[tokio::test]
    async fn test_generate_unique_salts() {
        let pool = setup_test_db().await;

        let result1 = generate(&pool, DIFFICULTY::MEDIUM).await.unwrap();
        let result2 = generate(&pool, DIFFICULTY::MEDIUM).await.unwrap();

        assert_ne!(
            result1.salt, result2.salt,
            "generated salts should be unique"
        );
    }

    #[tokio::test]
    async fn test_verify_challenge() {
        let pool = setup_test_db().await;
        let challenge = generate(&pool, DIFFICULTY::NONE).await.unwrap();
        assert!(verify(&pool, &challenge.key, 0).await.unwrap());
        // try to reuse
        assert!(!verify(&pool, &challenge.key, 0).await.unwrap());
    }

    #[tokio::test]
    async fn test_solve_pow_none_difficulty() {
        let pool = setup_test_db().await;
        let challenge = generate(&pool, DIFFICULTY::NONE).await.unwrap();

        let nonce = solve_pow(&challenge);
        assert!(nonce.is_some(), "should be able to solve NONE difficulty");

        let nonce = nonce.unwrap();
        let nonce_bytes = nonce.to_le_bytes();

        let mut hasher = Sha256::new();
        hasher.update(&challenge.key);
        hasher.update(&challenge.salt);
        hasher.update(&nonce_bytes);
        let hash_result = hasher.finalize();

        assert!(
            hash_result.as_slice() < challenge.difficulty.as_slice(),
            "hash should be less than difficulty for NONE"
        );
    }

    #[tokio::test]
    async fn test_solve_pow_easy_difficulty() {
        let pool = setup_test_db().await;
        let challenge = generate(&pool, DIFFICULTY::EASY).await.unwrap();

        let nonce = solve_pow(&challenge);
        assert!(nonce.is_some(), "should be able to solve EASY difficulty");

        let nonce = nonce.unwrap();
        let nonce_bytes = nonce.to_le_bytes();

        let mut hasher = Sha256::new();
        hasher.update(&challenge.key);
        hasher.update(&challenge.salt);
        hasher.update(&nonce_bytes);
        let hash_result = hasher.finalize();

        assert!(
            hash_result.as_slice() < challenge.difficulty.as_slice(),
            "hash should be less than difficulty for EASY"
        );
    }

    #[tokio::test]
    #[cfg_attr(debug_assertions, ignore)]
    async fn test_solve_pow_medium_difficulty() {
        let pool = setup_test_db().await;
        let challenge = generate(&pool, DIFFICULTY::MEDIUM).await.unwrap();

        let nonce = solve_pow(&challenge);
        assert!(nonce.is_some(), "should be able to solve MEDIUM difficulty");

        let nonce = nonce.unwrap();
        let nonce_bytes = nonce.to_le_bytes();

        let mut hasher = Sha256::new();
        hasher.update(&challenge.key);
        hasher.update(&challenge.salt);
        hasher.update(&nonce_bytes);
        let hash_result = hasher.finalize();

        assert!(
            hash_result.as_slice() < challenge.difficulty.as_slice(),
            "hash should be less than difficulty for MEDIUM"
        );
    }

    #[tokio::test]
    #[cfg_attr(debug_assertions, ignore)]
    async fn test_solve_pow_hard_difficulty() {
        let pool = setup_test_db().await;
        let challenge = generate(&pool, DIFFICULTY::HARD).await.unwrap();

        let nonce = solve_pow(&challenge);
        assert!(nonce.is_some(), "should be able to solve HARD difficulty");

        let nonce = nonce.unwrap();
        let nonce_bytes = nonce.to_le_bytes();

        let mut hasher = Sha256::new();
        hasher.update(&challenge.key);
        hasher.update(&challenge.salt);
        hasher.update(&nonce_bytes);
        let hash_result = hasher.finalize();

        assert!(
            hash_result.as_slice() < challenge.difficulty.as_slice(),
            "hash should be less than difficulty for HARD"
        );
    }
}
