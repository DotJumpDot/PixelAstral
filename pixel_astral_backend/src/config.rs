use anyhow::{Context, Result};
use std::env;

#[derive(Debug, Clone)]
pub struct Config {
    pub database_url: String,
    pub supabase_url: String,
    pub supabase_key: String,
    pub anon_key: String,
    pub jwt_secret: String,
    pub cors_allowed_origins: String,
    pub api_port: u16,
}

impl Config {
    pub fn from_env() -> Result<Self> {
        dotenvy::dotenv().ok();

        let database_url = env::var("DATABASE_URL")
            .context("DATABASE_URL must be set")?;

        let supabase_url = env::var("SUPABASE_URL")
            .context("SUPABASE_URL must be set")?;

        let supabase_key = env::var("SUPABASE_KEY")
            .context("SUPABASE_KEY must be set")?;

        let anon_key = env::var("ANON_KEY")
            .unwrap_or_default();

        let jwt_secret = env::var("SUPABASE_API")
            .context("SUPABASE_API (JWT secret) must be set")?;

        let cors_allowed_origins = env::var("CORS_ALLOWED_ORIGINS")
            .unwrap_or_else(|_| "http://localhost:3000".to_string());

        let api_port = env::var("API_PORT")
            .unwrap_or_else(|_| "3000".to_string())
            .parse()
            .context("API_PORT must be a valid number")?;

        Ok(Self {
            database_url,
            supabase_url,
            supabase_key,
            anon_key,
            jwt_secret,
            cors_allowed_origins,
            api_port,
        })
    }
}
