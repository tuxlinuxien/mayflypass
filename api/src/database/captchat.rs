use anyhow;
use captcha::{self as cap, filters::Dots, filters::Grid, filters::Noise, filters::Wave};

#[derive(Debug, Clone)]
pub struct CaptchatResult {
    pub id: String,
    pub code: String,
    pub image: String,
}

pub async fn generate(pool: &sqlx::SqlitePool) -> anyhow::Result<CaptchatResult> {
    let id = uuid::Uuid::now_v7().to_string();
    let mut cap = cap::Captcha::new();
    cap.set_chars(&[
        '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'C', 'F', 'H', 'Z', 'X',
    ]);
    cap.add_chars(5);
    cap.apply_filter(Wave::new(2.0, 10.0));
    cap.apply_filter(Noise::new(0.1));
    cap.apply_filter(Grid::new(10, 10));
    cap.apply_filter(Dots::new(10).max_radius(4).min_radius(3));
    cap.view(220, 120);
    let code = cap.chars_as_string();
    let image = cap
        .as_base64()
        .ok_or(anyhow::format_err!("couldn't generate captchat"))?;
    sqlx::query(
        r"
        INSERT INTO capchat_token (id, code)
        VALUES (?, ?)
        ",
    )
    .bind(&id)
    .bind(&code)
    .execute(pool)
    .await?;
    Ok(CaptchatResult { id, code, image })
}

pub async fn verify(pool: &sqlx::SqlitePool, id: &str, code: &str) -> anyhow::Result<bool> {
    let row = sqlx::query_as::<_, (String,)>(
        r"DELETE FROM capchat_token WHERE id = ? AND valid_until > datetime('now') RETURNING code",
    )
    .bind(id)
    .fetch_optional(pool)
    .await?;
    let stored_code = if let Some((code,)) = row {
        code
    } else {
        return Ok(false);
    };
    Ok(stored_code.eq_ignore_ascii_case(code))
}

#[cfg(test)]
mod test {
    use super::*;

    #[tokio::test]
    async fn test_generate() {
        let pool = super::super::create_pool("sqlite::memory:", 1)
            .await
            .unwrap();
        super::super::run_migrations(&pool).await.unwrap();
        let res = generate(&pool).await.unwrap();
        assert!(!res.id.is_empty());
        assert_eq!(res.code.len(), 5);
        assert!(verify(&pool, &res.id, &res.code).await.unwrap());
        assert!(!verify(&pool, &res.id, &res.code).await.unwrap()); // single-use
    }
}
