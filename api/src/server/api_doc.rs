/// Embedded OpenAPI 3.0 spec (manually crafted JSON).
const OPENAPI_JSON: &str = include_str!("openapi.json");

/// Swagger UI HTML page.
const SWAGGER_HTML: &str = include_str!("swagger_ui.html");

#[axum::debug_handler]
pub async fn openapi_handler() -> impl axum::response::IntoResponse {
    (
        axum::http::StatusCode::OK,
        [("Content-Type", "application/json")],
        OPENAPI_JSON,
    )
}

#[axum::debug_handler]
pub async fn docs_html() -> impl axum::response::IntoResponse {
    (
        axum::http::StatusCode::OK,
        [("Content-Type", "text/html; charset=utf-8")],
        SWAGGER_HTML,
    )
}
