use crate::constants::{
    PASSWORD_I_COST, PASSWORD_M_COST, PASSWORD_OUTPUT_LEN, PASSWORD_P_COST, PASSWORD_SALT_LEN,
};
use argon2::{Params, PasswordHasher, PasswordVerifier, password_hash::SaltString};

pub fn gen_bytes(len: usize) -> Vec<u8> {
    let mut data = vec![0u8; len];
    getrandom::fill(&mut data).expect("rng bytes");
    data
}

// Returns (phc_hash_string, raw_salt_bytes). The PHC string embeds the salt,
// so only the hash string is needed for verification; raw salt is stored separately.
pub async fn hash_password(password: &[u8]) -> String {
    let password = password.to_vec();
    // move argon2 into a spawn_blocking block or the whole thread will be blocked.
    tokio::task::spawn_blocking(move || {
        let params = Params::new(
            PASSWORD_M_COST,
            PASSWORD_I_COST,
            PASSWORD_P_COST,
            Some(PASSWORD_OUTPUT_LEN),
        )
        .expect("argon2 param");
        let hasher =
            argon2::Argon2::new(argon2::Algorithm::Argon2id, argon2::Version::V0x13, params);
        let salt_bytes = gen_bytes(PASSWORD_SALT_LEN);
        let salt = SaltString::encode_b64(&salt_bytes).expect("generate argon2 salt");
        hasher.hash_password(&password, &salt).unwrap().to_string()
    })
    .await
    .unwrap()
}

// hash the raw password and compare the output using constant time
// equlity.
pub async fn verify_password(password: &[u8], password_hash: &str) -> bool {
    let password = password.to_vec();
    let password_hash = password_hash.to_string();
    // move argon2 in a spawn_blocking block or the whole thread
    // will be blocked.
    tokio::task::spawn_blocking(move || {
        let parsed = match argon2::PasswordHash::new(&password_hash) {
            Ok(h) => h,
            Err(_) => return false,
        };
        argon2::Argon2::default()
            .verify_password(&password, &parsed)
            .is_ok()
    })
    .await
    .unwrap()
}

#[cfg(test)]
#[tokio::test]
pub async fn test_password_valid() {
    let hash = hash_password("1234567".as_bytes()).await;
    assert!(verify_password("1234567".as_bytes(), &hash).await);
}

#[cfg(test)]
#[tokio::test]
pub async fn test_password_invalid() {
    let hash = hash_password("1234567".as_bytes()).await;
    assert!(!verify_password("12345678".as_bytes(), &hash).await);
}
