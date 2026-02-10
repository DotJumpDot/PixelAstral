# PixelAstral Database Schema

## Table of Contents
- [Overview](#overview)
- [Core Entities](#core-entities)
- [Entity Relationships](#entity-relationships)
- [SQL Schema](#sql-schema)
- [Migration Notes](#migration-notes)

## Overview

This document describes the complete database schema for PixelAstral, a retro-themed collection app for managing games, movies, manga, and novels.

## Core Entities

### Users
| Column      | Type      | Nullable | Description                              |
| ----------- | --------- | -------- | ---------------------------------------- |
| id          | UUID      | No       | Primary key                              |
| email       | TEXT      | No       | User email (unique)                       |
| password_hash | TEXT     | No       | Bcrypt hashed password                    |
| created_at  | TIMESTAMP | No       | Account creation timestamp                |
| updated_at  | TIMESTAMP | Yes      | Last update timestamp                     |

### Games
| Column     | Type      | Nullable | Description                        |
| ---------- | --------- | -------- | ---------------------------------- |
| id         | UUID      | No       | Primary key                        |
| user_id    | UUID      | No       | Foreign key to users.id            |
| title      | TEXT      | No       | Game title                         |
| genre      | TEXT      | Yes      | Game genre (Action, RPG, etc.)     |
| rating     | INTEGER   | Yes      | Rating 1-5                        |
| status     | TEXT      | No       | Playing, Completed, Plan to Play, Dropped |
| notes      | TEXT      | Yes      | User notes about the game          |
| created_at | TIMESTAMP | No       | Creation timestamp                 |
| updated_at | TIMESTAMP | Yes      | Last update timestamp               |

### Movies
| Column     | Type      | Nullable | Description                        |
| ---------- | --------- | -------- | ---------------------------------- |
| id         | UUID      | No       | Primary key                        |
| user_id    | UUID      | No       | Foreign key to users.id            |
| title      | TEXT      | No       | Movie title                        |
| genre      | TEXT      | Yes      | Movie genre (Action, Drama, etc.)   |
| rating     | INTEGER   | Yes      | Rating 1-5                        |
| status     | TEXT      | No       | Watching, Completed, Plan to Watch, Dropped |
| notes      | TEXT      | Yes      | User notes about the movie          |
| created_at | TIMESTAMP | No       | Creation timestamp                 |
| updated_at | TIMESTAMP | Yes      | Last update timestamp               |

### Manga
| Column     | Type      | Nullable | Description                        |
| ---------- | --------- | -------- | ---------------------------------- |
| id         | UUID      | No       | Primary key                        |
| user_id    | UUID      | No       | Foreign key to users.id            |
| title      | TEXT      | No       | Manga title                        |
| genre      | TEXT      | Yes      | Manga genre (Shonen, Seinen, etc.) |
| rating     | INTEGER   | Yes      | Rating 1-5                        |
| status     | TEXT      | No       | Reading, Completed, Plan to Read, Dropped |
| notes      | TEXT      | Yes      | User notes about the manga         |
| created_at | TIMESTAMP | No       | Creation timestamp                 |
| updated_at | TIMESTAMP | Yes      | Last update timestamp               |

### Novels
| Column     | Type      | Nullable | Description                        |
| ---------- | --------- | -------- | ---------------------------------- |
| id         | UUID      | No       | Primary key                        |
| user_id    | UUID      | No       | Foreign key to users.id            |
| title      | TEXT      | No       | Novel title                        |
| genre      | TEXT      | Yes      | Novel genre (Fantasy, Sci-Fi, etc.) |
| rating     | INTEGER   | Yes      | Rating 1-5                        |
| status     | TEXT      | No       | Reading, Completed, Plan to Read, Dropped |
| notes      | TEXT      | Yes      | User notes about the novel         |
| created_at | TIMESTAMP | No       | Creation timestamp                 |
| updated_at | TIMESTAMP | Yes      | Last update timestamp               |

## Entity Relationships

```
users (1) ──── (many) games
users (1) ──── (many) movies
users (1) ──── (many) manga
users (1) ──── (many) novels
```

Each user can have multiple games, movies, manga, and novels. Each collection item belongs to exactly one user.

## SQL Schema

### Create Tables

```sql
-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Games table
CREATE TABLE IF NOT EXISTS games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    genre TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    status TEXT NOT NULL CHECK (status IN ('Playing', 'Completed', 'Plan to Play', 'Dropped')),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Movies table
CREATE TABLE IF NOT EXISTS movies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    genre TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    status TEXT NOT NULL CHECK (status IN ('Watching', 'Completed', 'Plan to Watch', 'Dropped')),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Manga table
CREATE TABLE IF NOT EXISTS manga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    genre TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    status TEXT NOT NULL CHECK (status IN ('Reading', 'Completed', 'Plan to Read', 'Dropped')),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Novels table
CREATE TABLE IF NOT EXISTS novels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    genre TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    status TEXT NOT NULL CHECK (status IN ('Reading', 'Completed', 'Plan to Read', 'Dropped')),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_games_user_id ON games(user_id);
CREATE INDEX IF NOT EXISTS idx_movies_user_id ON movies(user_id);
CREATE INDEX IF NOT EXISTS idx_manga_user_id ON manga(user_id);
CREATE INDEX IF NOT EXISTS idx_novels_user_id ON novels(user_id);
```

## Migration Notes

When deploying to production:

1. Review all SQL changes
2. Backup existing data
3. Add proper constraints and indexes
4. Test migrations in staging first
5. The `gen_random_uuid()` function requires the `pgcrypto` extension in PostgreSQL
