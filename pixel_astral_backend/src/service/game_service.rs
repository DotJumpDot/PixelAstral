use anyhow::{Context, Result};
use uuid::Uuid;

use crate::sql::game_sql;
use crate::type::game_type::{CreateGameRequest, Game, UpdateGameRequest};
use sqlx::PgPool;

pub struct GameService;

impl GameService {
    pub async fn create(
        pool: &PgPool,
        user_id: Uuid,
        request: CreateGameRequest,
    ) -> Result<Game> {
        game_sql::create_game(pool, user_id, request)
            .await
            .context("Failed to create game")
    }

    pub async fn get_all_by_user(
        pool: &PgPool,
        user_id: Uuid,
    ) -> Result<Vec<Game>> {
        game_sql::find_all_games_by_user(pool, user_id)
            .await
            .context("Failed to get games")
    }

    pub async fn get_by_id(
        pool: &PgPool,
        id: Uuid,
        user_id: Uuid,
    ) -> Result<Option<Game>> {
        game_sql::find_game_by_id(pool, id, user_id)
            .await
            .context("Failed to get game")
    }

    pub async fn update(
        pool: &PgPool,
        id: Uuid,
        user_id: Uuid,
        request: UpdateGameRequest,
    ) -> Result<Option<Game>> {
        game_sql::update_game(pool, id, user_id, request)
            .await
            .context("Failed to update game")
    }

    pub async fn delete(
        pool: &PgPool,
        id: Uuid,
        user_id: Uuid,
    ) -> Result<bool> {
        game_sql::delete_game(pool, id, user_id)
            .await
            .context("Failed to delete game")
    }
}
