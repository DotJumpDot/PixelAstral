use crate::type::game_type::{CreateGameRequest, Game, UpdateGameRequest};
use sqlx::PgPool;
use uuid::Uuid;

pub async fn create_game(
    pool: &PgPool,
    user_id: Uuid,
    request: CreateGameRequest,
) -> Result<Game, sqlx::Error> {
    sqlx::query_as!(
        Game,
        r#"
        INSERT INTO games (user_id, title, genre, rating, status, notes)
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id, user_id, title, genre, rating, status, notes, created_at, updated_at
        "#,
        user_id,
        request.title,
        request.genre,
        request.rating,
        request.status,
        request.notes
    )
    .fetch_one(pool)
    .await
}

pub async fn find_all_games_by_user(
    pool: &PgPool,
    user_id: Uuid,
) -> Result<Vec<Game>, sqlx::Error> {
    sqlx::query_as!(
        Game,
        r#"
        SELECT id, user_id, title, genre, rating, status, notes, created_at, updated_at
        FROM games
        WHERE user_id = $1
        ORDER BY created_at DESC
        "#,
        user_id
    )
    .fetch_all(pool)
    .await
}

pub async fn find_game_by_id(
    pool: &PgPool,
    id: Uuid,
    user_id: Uuid,
) -> Result<Option<Game>, sqlx::Error> {
    sqlx::query_as!(
        Game,
        r#"
        SELECT id, user_id, title, genre, rating, status, notes, created_at, updated_at
        FROM games
        WHERE id = $1 AND user_id = $2
        "#,
        id,
        user_id
    )
    .fetch_optional(pool)
    .await
}

pub async fn update_game(
    pool: &PgPool,
    id: Uuid,
    user_id: Uuid,
    request: UpdateGameRequest,
) -> Result<Option<Game>, sqlx::Error> {
    sqlx::query_as!(
        Game,
        r#"
        UPDATE games
        SET title = COALESCE($1, title),
            genre = COALESCE($2, genre),
            rating = COALESCE($3, rating),
            status = COALESCE($4, status),
            notes = COALESCE($5, notes),
            updated_at = CURRENT_TIMESTAMP
        WHERE id = $6 AND user_id = $7
        RETURNING id, user_id, title, genre, rating, status, notes, created_at, updated_at
        "#,
        request.title,
        request.genre,
        request.rating,
        request.status,
        request.notes,
        id,
        user_id
    )
    .fetch_optional(pool)
    .await
}

pub async fn delete_game(
    pool: &PgPool,
    id: Uuid,
    user_id: Uuid,
) -> Result<bool, sqlx::Error> {
    let result = sqlx::query!(
        r#"
        DELETE FROM games
        WHERE id = $1 AND user_id = $2
        "#,
        id,
        user_id
    )
    .execute(pool)
    .await?;

    Ok(result.rows_affected() > 0)
}
