use thiserror::Error;

impl From<sqlx::Error> for Error {
    fn from(value: sqlx::Error) -> Self {
        match &value {
            sqlx::Error::Database(e) => {
                if e.is_unique_violation() {
                    return Error::UniqueViolation {
                        contraint: e.to_string(),
                    };
                } else if e.is_check_violation() {
                    return Error::CheckViolation {
                        contraint: e.to_string(),
                    };
                } else if e.is_foreign_key_violation() {
                    return Error::ForeignKeyViolation {
                        contraint: e.to_string(),
                    };
                }
                return Error::Other(value);
            }
            _ => return Error::Other(value),
        }
    }
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("unique violation: {contraint}")]
    UniqueViolation { contraint: String },
    #[error("check violation: {contraint}")]
    CheckViolation { contraint: String },
    #[error("foreign key violation: {contraint}")]
    ForeignKeyViolation { contraint: String },
    #[error("database error: {0}")]
    Other(sqlx::Error),
}
