use super::constants;
use rand::TryRng;
use rand::rngs::SysRng;
use scrypt::{Params, scrypt};
use subtle::ConstantTimeEq;

pub fn gen_bytes(len: usize) -> Vec<u8> {
    let mut data = vec![0u8; len];
    SysRng.try_fill_bytes(&mut data).expect("SysRng failed");
    data
}

fn new_scrypt_params() -> Params {
    Params::new(
        constants::SCRYPT_LOG_N,
        constants::SCRYPT_R,
        constants::SCRYPT_P,
    )
    .expect("valid scrypt params")
}

// hash the raw password with script and return the secret used
// to salt the password.
pub async fn hash_password(password: &str) -> (String, Vec<u8>) {
    let password = password.to_string();
    // move scrypt in a spawn_blocking block or the whole thread
    // will be blocked.
    tokio::task::spawn_blocking(move || {
        let secret = gen_bytes(constants::PASSWORD_SECRET_LEN);
        let mut hash = vec![0u8; constants::SCRYPT_OUTPUT_LEN];
        let params = new_scrypt_params();
        scrypt(password.as_bytes(), &secret, &params, &mut hash).expect("scrypt failed");
        (hex::encode(&hash), secret)
    })
    .await
    .unwrap()
}

// hash the raw password and compare the output using constant time
// equlity.
pub async fn verify_password(password: &str, hash: &str, secret: &[u8]) -> bool {
    let Ok(expected) = hex::decode(hash) else {
        return false;
    };
    let password = password.to_string();
    let secret = secret.to_vec();
    // move scrypt in a spawn_blocking block or the whole thread
    // will be blocked.
    tokio::task::spawn_blocking(move || {
        let mut computed = vec![0u8; constants::SCRYPT_OUTPUT_LEN];
        let params = new_scrypt_params();
        if scrypt(password.as_bytes(), &secret, &params, &mut computed).is_err() {
            return false;
        }
        computed.ct_eq(&expected).into()
    })
    .await
    .unwrap()
}

#[cfg(test)]
#[tokio::test]
pub async fn test_password_valid() {
    let (password_hash, password_salt) = hash_password("1234567").await;
    assert!(verify_password("1234567", &password_hash, &password_salt).await);
}

#[cfg(test)]
#[tokio::test]
pub async fn test_password_invalid() {
    let (password_hash, password_salt) = hash_password("1234567").await;
    assert!(!verify_password("12345678", &password_hash, &password_salt).await);
}
