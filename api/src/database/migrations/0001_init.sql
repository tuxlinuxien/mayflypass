CREATE TABLE account (
    id BLOB PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    password_secret BYTEA NOT NULL,
    access_token_secret BYTEA NOT NULL,
    refresh_token_secret BYTEA NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);