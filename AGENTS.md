# AGENTS Guidelines for This Repository

## Project Name: PixelAstral

**A retro-themed collection app with star/universe aesthetic for managing games, movies, manga, and novels.**

### Core Features:

1. **Multi-Type Collections** - Track games, movies, manga, and novels
2. **Backend API** - RESTful API services built with Axum
3. **Frontend UI** - Cross-platform mobile/desktop applications with Flutter
4. **Data Layer** - Supabase for database and authentication

### Technology Stack:

- **Backend**: Rust (edition 2024) + Axum web framework in `pixel_astral_backend/`
- **Frontend**: Flutter (Dart SDK ^3.10.8) in `pixel_astral_frontend/`
- **Infrastructure**: Supabase (PostgreSQL + Auth + Storage)

## 1. Development Workflow

### Backend (Rust)

- Use `cargo` for dependency management and building
- Run tests with `cargo test`
- Build with `cargo build --release` for production
- Use `cargo check` for faster compilation during development

### Frontend (Flutter)

- Use `flutter pub get` to install dependencies
- Run `flutter run` to start development
- Use `flutter test` to run tests
- Use `flutter analyze` for static analysis

### Database

- Schema documentation in `Docs/Schema.md`
- Run migrations carefully — always review before executing

## 2. Backend Architecture & Core Entities

### Backend File Structure

```
pixel_astral_backend/src/
├── main.rs
├── api/
│   ├── {feature}/
│   │   ├── {feature}_api.rs
│   │   ├── {feature}_service.rs
│   │   ├── {feature}_query.rs
│   │   └── {feature}_type.rs
├── service/
├── query/
├── type/
└── database/
    └── db.rs
```

## 3. Keep Dependencies in Sync

### Backend

When adding/updating packages:

```bash
cd pixel_astral_backend
cargo add <package>
```

### Frontend

When adding/updating packages:

```bash
cd pixel_astral_frontend
flutter pub add <package>
```

## 4. File Naming Conventions

### Backend (Rust)

| Layer      | Pattern                | Example                                                       |
| ---------- | ---------------------- | ------------------------------------------------------------- |
| API Routes | `{feature}_api.rs`     | `game_api.rs`, `manga_api.rs`, `movie_api.rs`, `novel_api.rs` |
| Services   | `{feature}_service.rs` | `game_service.rs`, `manga_service.rs`, `user_service.rs`      |
| Queries    | `{feature}_query.rs`   | `game_query.rs`, `manga_query.rs`, `user_query.rs`            |
| Types      | `{feature}_type.rs`    | `game_type.rs`, `manga_type.rs`, `user_type.rs`               |

**Rules:**

- Use **snake_case** for all Rust files
- Feature name should match across all layers
- Use PascalCase for types/structs within files

### Frontend (Flutter/Dart)

| Layer        | Pattern           | Example                                                                 |
| ------------ | ----------------- | ----------------------------------------------------------------------- |
| Widgets      | `PascalCase.dart` | `GameCard.dart`, `MangaList.dart`, `MovieDetail.dart`, `NovelForm.dart` |
| Models/Types | `lowercase.dart`  | `game.dart`, `manga.dart`, `movie.dart`, `novel.dart`                   |
| Services     | `lowercase.dart`  | `supabase_service.dart`, `collection_service.dart`, `auth_service.dart` |

## 5. Coding Conventions

### Backend (Rust)

- Follow Rust naming conventions: snake_case for functions/vars, PascalCase for types
- Use `cargo fmt` for consistent formatting
- Use `cargo clippy` for linting
- Follow layered architecture:
  - `api/` → Route handlers (thin layer, delegates to services)
  - `service/` → Business logic (orchestrates queries)
  - `query/` → Database queries
  - `type/` → Structs and enums

### Frontend (Flutter/Dart)

- Follow Dart style guide (https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format .` for consistent formatting
- Prefer stateless widgets when possible
- Co-locate component styles with components

## 6. Database

- **Supabase (PostgreSQL)** for development and production
- Supabase Auth for user authentication
- Supabase Storage for image/file uploads
- Schema documentation in `Docs/Schema.md`
- Run migrations carefully — always review before executing
- Use Supabase Dashboard for database management

## 7. Useful Commands

### Backend

| Command                                | Purpose            |
| -------------------------------------- | ------------------ |
| `cd pixel_astral_backend && cargo run` | Start dev server   |
| `cargo check`                          | Fast compile check |
| `cargo test`                           | Run tests          |
| `cargo clippy`                         | Run linter         |
| `cargo fmt`                            | Format code        |
| `cargo add <package>`                  | Add dependency     |

### Frontend

| Command                                   | Purpose                                       |
| ----------------------------------------- | --------------------------------------------- |
| `cd pixel_astral_frontend && flutter run` | Start dev server on connected device/emulator |
| `flutter pub get`                         | Install dependencies                          |
| `flutter test`                            | Run tests                                     |
| `flutter analyze`                         | Run static analysis                           |
| `flutter format .`                        | Format all Dart files                         |
| `flutter pub add <package>`               | Add dependency                                |

## 8. Key Technologies

**Backend Stack:**

- Rust 2024 edition
- Axum web framework (async HTTP server)
- Supabase client for database and auth
- Cargo (package manager)

**Frontend Stack:**

- Flutter (cross-platform UI framework)
- Dart SDK ^3.10.8
- Material Design 3 components
- Supabase Flutter SDK for backend integration

**DevOps:**

- Cargo clippy (Rust linter)
- flutter_lints (Dart linter)
- flutter analyze (static analysis)
- Supabase CLI for database migrations
