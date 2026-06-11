use axum::http::{HeaderValue, header::InvalidHeaderValue};
use cookie::time::Duration;

pub struct RefreshTokenCookie(HeaderValue);

impl From<RefreshTokenCookie> for HeaderValue {
    fn from(cookie: RefreshTokenCookie) -> Self {
        cookie.0
    }
}

impl From<HeaderValue> for RefreshTokenCookie {
    fn from(value: HeaderValue) -> Self {
        RefreshTokenCookie(value)
    }
}

impl RefreshTokenCookie {
    pub fn token(&self) -> Result<String, anyhow::Error> {
        let s = self.0.to_str()?;
        let cookie = cookie::Cookie::parse(s)?;
        Ok(cookie.value().to_owned())
    }

    pub fn build(refresh_token: &str, secure: bool) -> Result<RefreshTokenCookie, anyhow::Error> {
        cookie::Cookie::build(("refresh_token", refresh_token))
            .max_age(Duration::days(30))
            .path("/")
            .same_site(if !secure {
                cookie::SameSite::None
            } else {
                cookie::SameSite::Lax
            })
            .secure(secure)
            .http_only(true)
            .to_string()
            .parse::<HeaderValue>()
            .map(RefreshTokenCookie)
            .map_err(|e| anyhow::anyhow!("build cookie error: {:?}", e))
    }
}

impl TryFrom<String> for RefreshTokenCookie {
    type Error = InvalidHeaderValue;

    fn try_from(refresh_token: String) -> Result<Self, Self::Error> {
        cookie::Cookie::build(("refresh_token", refresh_token.as_str()))
            .max_age(Duration::days(30))
            .path("/")
            .secure(true)
            .http_only(true)
            .to_string()
            .parse::<HeaderValue>()
            .map(RefreshTokenCookie)
    }
}
