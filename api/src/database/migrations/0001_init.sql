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
    version INTEGER NOT NULL,
    -- Instead of deleting the row from the database, mark it as deleted
    -- and set deleted_at or users that have multiple devices will see the
    -- row reappearing again.
    -- Delete the row from the db when deleted_at is older than X months
    -- so it gives plenty of time for all the devices to be in sync
    -- with the database.
    deleted BOOLEAN NOT NULL DEFAULT False,
    encrypted_dek BLOB NOT NULL,
    encrypted_payload BLOB NOT NULL,
    PRIMARY KEY (id, account_id)
);