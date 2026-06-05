CREATE TABLE account (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE capchat_token (
    id TEXT PRIMARY KEY,
    code TEXT NOT NULL,
    valid_until TEXT NOT NULL DEFAULT (datetime('now', '+2 minutes'))
);