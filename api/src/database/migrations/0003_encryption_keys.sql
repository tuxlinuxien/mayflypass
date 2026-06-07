CREATE TABLE encryption_key (
    id TEXT NOT NULL PRIMARY KEY,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE encrypted_otp_secret (
    id TEXT NOT NULL PRIMARY KEY,
    account_id TEXT NOT NULL REFERENCES account(id),
    encryption_key_id TEXT NOT NULL REFERENCES encryption_key(id),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    version INTEGER NOT NULL,
    encrypted_payload TEXT NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT False
);
