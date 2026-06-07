use anyhow;
use captcha::{self as cap, filters::Dots, filters::Grid, filters::Noise, filters::Wave};
use serde::Serialize;

#[derive(Debug, Clone, Serialize)]
pub struct CaptchatResult {
    pub id: String,
    pub image: String,
}

fn make_captcha() -> anyhow::Result<(String, String)> {
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
    Ok((code, image))
}

pub async fn generate<'c, E: sqlx::Executor<'c, Database = sqlx::Sqlite>>(
    executor: E,
) -> anyhow::Result<(CaptchatResult, String)> {
    let id = uuid::Uuid::now_v7().to_string();
    // Captcha::new is not Send so we need to spawn it into another thread.
    let (code, image) = tokio::task::spawn_blocking(move || make_captcha()).await??;
    // save the code and id.
    sqlx::query(
        r"
        INSERT INTO capchat_token (id, code)
        VALUES (?, ?)
        ",
    )
    .bind(&id)
    .bind(&code)
    .execute(executor)
    .await?;

    // No need to store the image because it will directly be passed to the
    // UI.
    Ok((CaptchatResult { id, image }, code))
}

pub async fn verify<'c, E: sqlx::Executor<'c, Database = sqlx::Sqlite>>(
    executor: E,
    id: &str,
    code: &str,
) -> Result<bool, sqlx::Error> {
    // That's right, sqlite can return on a row from a delete query so we save
    // one query and the operation is atomic.
    let row = sqlx::query_as::<_, (String,)>(
        r"
        DELETE FROM capchat_token
        WHERE id = ? AND valid_until > datetime('now')
        RETURNING code",
    )
    .bind(id)
    .fetch_optional(executor)
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
        let (res, code) = generate(&pool).await.unwrap();
        assert!(!res.id.is_empty());
        assert!(!res.image.is_empty());
        // fetch the code stored in the database

        // make sure verify can be used only once.
        assert!(verify(&pool, &res.id, &code).await.unwrap());
        assert!(!verify(&pool, &res.id, &code).await.unwrap()); // single use
    }
}
