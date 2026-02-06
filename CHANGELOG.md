# Changelog

All notable changes to PixelAstral will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-02-06

### Added

- **Initial Release**: Project setup with monorepo structure
- **Backend**: Rust (edition 2024) + Axum web framework initial setup
- **Frontend**: Flutter (Dart SDK ^3.10.8) initial framework setup
- **Database**: Supabase (PostgreSQL + Auth + Storage) integration planned
- **Documentation**: AGENTS.md, Schema.md, and README.md created
- **Project Structure**:
  - `pixel_astral_backend/` - Rust backend application with Axum
  - `pixel_astral_frontend/` - Flutter cross-platform frontend
  - `Docs/` - Documentation directory
  - Root `.gitignore`, `LICENSE`, `CHANGELOG.md`, `AGENTS.md`, `README.md`

### Project Concept

- **Theme**: Pixel Astral - Star/universe retro arcade game aesthetic
- **Core Purpose**: Collection management app for games, movies, manga, and novels
- **Key Features**:
  - Create blog-style entries for manga (images, name, URL, page tracking, chapter progress, status: ongoing/finished)
  - Game collection with progress tracking
  - Movie collection with watch status
  - Novel collection with chapter/page tracking
  - Different table schemas for each content type

## [Future Versions]

### Planned Features

- Backend API implementation with Axum
- Supabase database schema implementation
- User authentication with Supabase Auth
- Game collection CRUD operations
- Movie collection CRUD operations
- Manga collection CRUD operations (chapters, pages, status)
- Novel collection CRUD operations (chapters, pages, status)
- Image upload and storage with Supabase Storage
- Retro pixel-art themed UI components
- Search and filtering across collections
- Import/export functionality
- Statistics dashboard
