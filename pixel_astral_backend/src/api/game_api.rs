use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{delete, get, post, put},
    Router,
};
use uuid::Uuid;

use crate::service::game_service::GameService;
use crate::type::game_type::{CreateGameRequest, Game, UpdateGameRequest};

pub fn routes() -> Router<sqlx::PgPool> {
    Router::new()
        .route("/", get(get_games))
        .route("/", post(create_game))
        .route("/:id", get(get_game))
        .route("/:id", put(update_game))
        .route("/:id", delete(delete_game))
}

async fn get_games(
    Path(user_id): Path<Uuid>,
    State(pool): State<sqlx::PgPool>,
) -> Result<Json<Vec<Game>>, StatusCode> {
    GameService::get_all_by_user(&pool, user_id)
        .await
        .map(|games| Json(games))
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)
}

async fn create_game(
    Path(user_id): Path<Uuid>,
    State(pool): State<sqlx::PgPool>,
    Json(request): Json<CreateGameRequest>,
) -> Result<Json<Game>, StatusCode> {
    GameService::create(&pool, user_id, request)
        .await
        .map(|game| Json(game))
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)
}

async fn get_game(
    Path((user_id, game_id)): Path<(Uuid, Uuid)>,
    State(pool): State<sqlx::PgPool>,
) -> Result<Json<Game>, StatusCode> {
    GameService::get_by_id(&pool, game_id, user_id)
        .await
        .map(|game_opt| {
            game_opt.map(Json).ok_or(StatusCode::NOT_FOUND)
        })
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
}

async fn update_game(
    Path((user_id, game_id)): Path<(Uuid, Uuid)>,
    State(pool): State<sqlx::PgPool>,
    Json(request): Json<UpdateGameRequest>,
) -> Result<Json<Game>, StatusCode> {
    GameService::update(&pool, game_id, user_id, request)
        .await
        .map(|game_opt| {
            game_opt.map(Json).ok_or(StatusCode::NOT_FOUND)
        })
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
}

async fn delete_game(
    Path((user_id, game_id)): Path<(Uuid, Uuid)>,
    State(pool): State<sqlx::PgPool>,
) -> Result<StatusCode, StatusCode> {
    GameService::delete(&pool, game_id, user_id)
        .await
        .map(|deleted| if deleted { StatusCode::NO_CONTENT } else { StatusCode::NOT_FOUND })
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)
}
