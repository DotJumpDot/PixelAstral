# PixelAstral

<div align="center">

**A retro-themed collection app for the digital universe**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## About PixelAstral

PixelAstral is a cross-platform collection application with a star/universe retro arcade game aesthetic. It allows users to create and manage collections of games, movies, manga, and novels with a beautiful, nostalgic pixel-art inspired interface.

## Features

- **Multi-Type Collections**: Track games, movies, manga, and novels
- **Detailed Entry Management**:
  - **Manga**: Cover images, titles, URLs, page tracking, chapter progress, status (ongoing/finished)
  - **Games**: Cover images, titles, platform info, progress tracking, completion status
  - **Movies**: Poster images, titles, release year, watch status, ratings
  - **Novels**: Cover images, titles, author, chapter/page tracking, reading status
- **Cross-Platform**: Available on mobile (iOS/Android), desktop (Windows, macOS, Linux), and web
- **Retro Arcade Theme**: Beautiful pixel-art inspired interface with star/universe motifs

## Technology Stack

### Backend

- **Rust 2024** - High-performance backend
- **Axum** - Modern, ergonomic web framework
- **Supabase** - Backend-as-a-Service for database and authentication

### Frontend

- **Flutter** - Cross-platform UI framework
- **Dart 3.10.8+** - Modern, reactive programming language
- **Material Design 3** - Beautiful, customizable components

## Project Structure

```
PixelAstral/
├── pixel_astral_backend/     # Rust backend with Axum
│   └── src/
│       ├── api/             # API routes
│       ├── service/         # Business logic
│       ├── query/           # Database queries
│       └── type/            # Type definitions
├── pixel_astral_frontend/    # Flutter frontend
│   └── lib/
│       ├── widgets/         # UI components
│       ├── models/          # Data models
│       └── services/        # API services
├── Docs/
│   └── Schema.md           # Database schema documentation
└── AGENTS.md               # Development guidelines
```

## Getting Started

### Prerequisites

- **Backend**: Rust 1.80+, Cargo
- **Frontend**: Flutter 3.24+, Dart 3.10.8+
- **Database**: Supabase account

### Backend Setup

```bash
cd pixel_astral_backend
cargo install
cargo run
```

### Frontend Setup

```bash
cd pixel_astral_frontend
flutter pub get
flutter run
```

## Development

For detailed development guidelines, see [AGENTS.md](AGENTS.md).

### Backend Commands

```bash
cd pixel_astral_backend
cargo run              # Start dev server
cargo test             # Run tests
cargo clippy           # Lint code
cargo fmt              # Format code
```

### Frontend Commands

```bash
cd pixel_astral_frontend
flutter run            # Start app
flutter test           # Run tests
flutter analyze        # Analyze code
flutter format .       # Format code
```

## Database Schema

The database schema is designed to support multiple collection types with shared and type-specific fields. See [Docs/Schema.md](Docs/Schema.md) for complete schema documentation.

### Core Entities

- **Users** - User accounts and authentication
- **Collections** - High-level collection organization
- **Games** - Game-specific data
- **Movies** - Movie-specific data
- **Manga** - Manga-specific data (chapters, pages, status)
- **Novels** - Novel-specific data (chapters, pages, status)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please read our development guidelines in [AGENTS.md](AGENTS.md).

## Roadmap

- [ ] User authentication with Supabase Auth
- [ ] CRUD operations for all collection types
- [ ] Image upload and storage
- [ ] Advanced filtering and search
- [ ] Import/export collections
- [ ] Social features (share collections)
- [ ] Statistics and analytics dashboard

---

**Made with ❤️ by DotJumpDot**

_Stars, pixels, and your digital universe_
