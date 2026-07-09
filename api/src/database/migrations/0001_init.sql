CREATE TABLE account (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    password_hash TEXT NOT NULL,
    password_updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE challenge (
    key BLOB NOT NULL,
    salt BLOB NOT NULL,
    difficulty BLOB NOT NULL,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+2 minutes'))
);

CREATE TABLE refresh_token (
    token_hash TEXT NOT NULL,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+720 hours'))
);

CREATE TABLE storage (
    id TEXT NOT NULL,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    updated_at_ms INTEGER NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT False,
    encrypted_dek BLOB NOT NULL,
    encrypted_payload BLOB NOT NULL,
    PRIMARY KEY (id, account_id)
);