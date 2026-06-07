use thiserror::Error;

impl From<sqlx::Error> for Error {
    fn from(value: sqlx::Error) -> Self {
        match &value {
            sqlx::Error::Database(e) => {
                if e.is_unique_violation() {
                    return Error::UniqueViolation {
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
    #[error("database error: {0}")]
    Other(sqlx::Error),
}
