use anyhow::{Context, Result};
use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::{Duration, Utc};
use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use uuid::Uuid;

use crate::sql::user_sql;
use crate::type::user_type::{AuthResponse, Claims, CreateUserRequest, LoginRequest, UserResponse};
use sqlx::PgPool;

pub struct UserService;

impl UserService {
    pub async fn signup(
        pool: &PgPool,
        request: CreateUserRequest,
    ) -> Result<AuthResponse> {
        let password_hash = hash(&request.password, DEFAULT_COST)
            .context("Failed to hash password")?;

        let user = user_sql::create_user(pool, &request.email, &password_hash)
            .await
            .context("Failed to create user")?;

        let token = Self::generate_token(user.id)?;

        Ok(AuthResponse {
            user: user.into(),
            token,
        })
    }

    pub async fn login(
        pool: &PgPool,
        request: LoginRequest,
    ) -> Result<AuthResponse> {
        let user = user_sql::find_user_by_email(pool, &request.email)
            .await
            .context("Failed to find user")?
            .ok_or_else(|| anyhow::anyhow!("Invalid email or password"))?;

        let is_valid = verify(&request.password, &user.password_hash)
            .context("Failed to verify password")?;

        if !is_valid {
            return Err(anyhow::anyhow!("Invalid email or password"));
        }

        let token = Self::generate_token(user.id)?;

        Ok(AuthResponse {
            user: user.into(),
            token,
        })
    }

    pub async fn get_user(
        pool: &PgPool,
        user_id: Uuid,
    ) -> Result<UserResponse> {
        let user = user_sql::find_user_by_id(pool, user_id)
            .await
            .context("Failed to find user")?
            .ok_or_else(|| anyhow::anyhow!("User not found"))?;

        Ok(user.into())
    }

    fn generate_token(user_id: Uuid) -> Result<String> {
        let expiration = Utc::now()
            .checked_add_signed(Duration::days(7))
            .expect("valid timestamp")
            .timestamp() as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            exp: expiration,
        };

        let secret = std::env::var("SUPABASE_API")
            .context("JWT secret not configured")?;

        encode(&Header::default(), &claims, &EncodingKey::from_secret(secret.as_ref()))
            .context("Failed to generate token")
    }

    pub fn verify_token(token: &str) -> Result<Uuid> {
        let secret = std::env::var("SUPABASE_API")
            .context("JWT secret not configured")?;

        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(secret.as_ref()),
            &Validation::default(),
        )
        .context("Invalid token")?;

        let user_id = Uuid::parse_str(&token_data.claims.sub)
            .context("Invalid user ID in token")?;

        Ok(user_id)
    }
}
