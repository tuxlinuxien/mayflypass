CREATE TABLE account (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    password_hash TEXT NOT NULL,
    password_updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    -- argon2id parameters
    kek_m_cost INTEGER NOT NULL,
    kek_t_cost INTEGER NOT NULL,
    kek_p_cost INTEGER NOT NULL,
    kek_output_len INTEGER NOT NULL,
    kek_salt BLOB NOT NULL
);

CREATE TABLE capchat_token (
    id TEXT PRIMARY KEY,
    code TEXT NOT NULL,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+2 minutes'))
);

CREATE TABLE refresh_token (
    token_hash TEXT NOT NULL,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+720 hours'))
);

CREATE TABLE encrypted_storage (
    id TEXT NOT NULL PRIMARY KEY,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    version INTEGER NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT False,
    encrypted_dek BLOB NOT NULL,
    encrypted_payload BLOB NOT NULL
);