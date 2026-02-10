use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use uuid::Uuid;
use utoipa::ToSchema;

use crate::service::user_service::UserService;
use crate::type::user_type::{AuthResponse, CreateUserRequest, LoginRequest, UserResponse};

pub fn routes() -> Router<sqlx::PgPool> {
    Router::new()
        .route("/signup", post(signup))
        .route("/login", post(login))
        .route("/me/:id", get(get_current_user))
}

#[utoipa::path(
    "/api/users/signup",
    post,
    tag = "auth",
    request_body = CreateUserRequest,
    responses(
        (status = 200, description = "User created successfully", body = AuthResponse),
        (status = 500, description = "Internal server error")
    )
)]
async fn signup(
    State(pool): State<sqlx::PgPool>,
    Json(request): Json<CreateUserRequest>,
) -> Result<Json<AuthResponse>, StatusCode> {
    UserService::signup(&pool, request)
        .await
        .map(|response| Json(response))
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)
}

#[utoipa::path(
    "/api/users/login",
    post,
    tag = "auth",
    request_body = LoginRequest,
    responses(
        (status = 200, description = "User logged in successfully", body = AuthResponse),
        (status = 401, description = "Invalid credentials")
    )
)]
async fn login(
    State(pool): State<sqlx::PgPool>,
    Json(request): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, StatusCode> {
    UserService::login(&pool, request)
        .await
        .map(|response| Json(response))
        .map_err(|_| StatusCode::UNAUTHORIZED)
}

#[utoipa::path(
    "/api/users/me/{id}",
    get,
    tag = "auth",
    params(
        ("id" = Uuid, Path, description = "User ID")
    ),
    responses(
        (status = 200, description = "User found", body = UserResponse),
        (status = 404, description = "User not found")
    )
)]
async fn get_current_user(
    Path(user_id): Path<Uuid>,
    State(pool): State<sqlx::PgPool>,
) -> Result<Json<UserResponse>, StatusCode> {
    UserService::get_user(&pool, user_id)
        .await
        .map(|response| Json(response))
        .map_err(|_| StatusCode::NOT_FOUND)
}
