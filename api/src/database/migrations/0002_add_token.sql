CREATE TABLE refresh_token (
    token_hash TEXT NOT NULL,
    account_id TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+720 hours'))
);