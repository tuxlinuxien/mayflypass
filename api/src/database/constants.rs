pub const PASSWORD_SECRET_LEN: usize = 32; //bytes
pub const ACCESS_TOKEN_SECRET_LEN: usize = 32; //bytes
pub const REFRESH_TOKEN_SECRET_LEN: usize = 32; //bytes

// Script parameters:
// Log_N=2^14
// r=8
// p=1
// output=64 bytes
// see OWASP baseline
pub const SCRYPT_LOG_N: u8 = 2 ^ 14;
pub const SCRYPT_R: u32 = 8;
pub const SCRYPT_P: u32 = 8;
pub const SCRYPT_OUTPUT_LEN: usize = 64;
