use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;
use sqlx::FromRow;
use utoipa::ToSchema;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow, ToSchema)]
pub struct Game {
    pub id: Uuid,
    pub user_id: Uuid,
    pub title: String,
    pub genre: Option<String>,
    pub rating: Option<i32>,
    pub status: String,
    pub notes: Option<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct CreateGameRequest {
    pub title: String,
    pub genre: Option<String>,
    pub rating: Option<i32>,
    pub status: String,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct UpdateGameRequest {
    pub title: Option<String>,
    pub genre: Option<String>,
    pub rating: Option<i32>,
    pub status: Option<String>,
    pub notes: Option<String>,
}

pub const GAME_STATUSES: &[&str] = &["Playing", "Completed", "Plan to Play", "Dropped"];
