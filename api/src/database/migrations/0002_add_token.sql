CREATE TABLE token (
    type TEXT NOT NULL,
    account TEXT NOT NULL REFERENCES account(id) ON DELETE CASCADE,
    signature TEXT NOT NULL UNIQUE,
    valid_until TEXT NOT NULL
);