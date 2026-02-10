mod api;
mod config;
mod db;
mod service;
mod sql;
mod type;

use api::{game_api, user_api};
use config::Config;
use db::Database;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde_json::json;

#[derive(OpenApi)]
#[openapi(
    paths(
        health_check,
        user_api::signup,
        user_api::login,
        user_api::get_current_user,
        game_api::get_games,
        game_api::create_game,
        game_api::get_game,
        game_api::update_game,
        game_api::delete_game,
    ),
    components(
        schemas(
            type::user_type::User,
            type::user_type::CreateUserRequest,
            type::user_type::LoginRequest,
            type::user_type::UserResponse,
            type::user_type::AuthResponse,
            type::game_type::Game,
            type::game_type::CreateGameRequest,
            type::game_type::UpdateGameRequest,
        )
    ),
    tags(
        (name = "health", description = "Health check endpoints"),
        (name = "auth", description = "Authentication endpoints"),
        (name = "games", description = "Game collection endpoints"),
    )
)]
struct ApiDoc;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    let config = Config::from_env()?;
    tracing::info!("Loaded configuration successfully");

    let database = Database::new(&config).await?;
    tracing::info!("Database connection pool created");

    database.test_connection().await?;
    tracing::info!("Database connection test passed");

    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    let app = Router::new()
        .route("/health", get(health_check))
        .route("/api/health", get(health_check))
        .nest("/api/users", user_api::routes())
        .nest("/api/users/:user_id/games", game_api::routes())
        .merge(SwaggerUi::new("/swagger-ui").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .layer(cors)
        .layer(TraceLayer::new_for_http())
        .with_state(database.pool);

    let addr = format!("0.0.0.0:{}", config.api_port);
    let listener = tokio::net::TcpListener::bind(&addr).await?;
    let swagger_url = format!("http://localhost:{}/swagger-ui", config.api_port);
    println!("Server started at: {}", swagger_url);
    tracing::info!("Server listening on {}", addr);

    axum::serve(listener, app).await?;

    Ok(())
}

#[utoipa::path(
    "/health",
    get,
    tag = "health",
    responses(
        (status = 200, description = "Health check passed", body = serde_json::Value),
        (status = 500, description = "Health check failed")
    )
)]
async fn health_check(State(pool): State<sqlx::PgPool>) -> Result<Json<serde_json::Value>, StatusCode> {
    sqlx::query("SELECT 1")
        .fetch_one(&pool)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(json!({
        "status": "healthy",
        "timestamp": chrono::Utc::now().to_rfc3339(),
    })))
}
