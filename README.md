# 🎬 Movie Universe
A Flutter application for discovering popular, top-rated, and searchable movies powered by The Movie Database (TMDB).

---

# 📖 Overview

Movie Universe is a Flutter application developed as a technical assessment.

The application allows users to browse, search and discover movies using **The Movie Database (TMDB)** API while demonstrating modern software engineering principles, scalable architecture and clean code practices.

Architecture and engineering decisions are documented in **`AGENTS.md`** and this README. **OpenSpec** change specs live under `openspec/changes/` (see the OpenSpec section below).

---

# 🎯 Objective

Develop a production-ready Flutter application that demonstrates:

- Software Engineering principles
- Clean Architecture
- SOLID Principles
- State Management
- Testability
- Scalability
- Documentation
- Code Quality

---

# ✨ Features

## Implemented

- 🎬 Popular Movies
- ⭐ Top Rated Movies
- 🔍 Search Movies by Name
- 📄 Movie Details
- ♾ Infinite Scroll Pagination
- ⚠ Error Handling
- 🔄 Loading States
- 📱 Responsive UI
- 🧪 Unit Tests
- 🧩 Widget Tests (design-system components, navigation flows)
- 🏗 Design System (Atomic Design under `lib/shared/design_system/`)

---

## Planned Improvements

- ❤️ Favorites
- 🌍 Localization
- 📥 Offline Cache
- 🎞 Similar Movies
- 🎭 Cast Details
- 📺 TV Shows
- 🔔 Push Notifications
- Integration Tests
- Golden Tests

---

## Implemented Platform Features

- 🌙 Dark / Light theme toggle via `themeModeProvider`

# 🏗 Architecture

The application follows **Clean Architecture** using a **Feature First** organization.

```text
Presentation
│
├── UI
├── Widgets
├── Riverpod Providers
│
Domain
│
├── Entities
├── Use Cases
├── Repository Contracts
│
Data
│
├── Remote Data Sources
├── DTOs
├── Repository Implementations
│
Core
│
├── Config & Environment
├── Data (shared DTOs & mappers)
├── Media (TmdbImageUrl)
├── Networking
├── Routing
├── Errors
├── Theme
└── Utilities
```

This architecture promotes:

- Separation of Concerns
- Testability
- Maintainability
- Scalability
- Reusability

---

# 📂 Project Structure

The planned directory structure follows Clean Architecture with a Feature First organization:

```text
lib/

├── core/
│   ├── config/        # EnvironmentConfig, .env wiring
│   ├── constants/
│   ├── data/          # Shared DTOs & mappers (TmdbMovieDto)
│   ├── errors/
│   ├── media/         # TmdbImageUrl
│   ├── network/
│   ├── router/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── movies/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── providers/
│   │           ├── movie_repository_provider.dart
│   │           ├── movie_usecase_providers.dart
│   │           ├── paginated_movies_notifier.dart   # shared pagination base
│   │           ├── popular_movies_provider.dart
│   │           ├── top_rated_movies_provider.dart
│   │           └── movie_details_provider.dart
│   └── search/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           └── providers/
│               ├── search_repository_provider.dart
│               ├── search_usecase_providers.dart
│               └── search_provider.dart
│
├── shared/
│   ├── design_system/ # atoms, molecules, models, templates
│   ├── mappers/       # Entity → display model mappers
│   └── widgets/       # Premium shared widgets (barrel re-exports)
│
└── main.dart
```

Provider wiring convention (both features):

```text
# Search
search_repository_provider.dart  → SearchRepository (DI only)
search_usecase_providers.dart    → searchMoviesProvider (SearchMovies use case)
search_provider.dart             → UI notifier (calls use case)

# Movies
movie_repository_provider.dart   → MovieRepository (DI only)
movie_usecase_providers.dart     → GetPopularMovies, GetTopRatedMovies, GetMovieDetails
paginated_movies_notifier.dart   → shared infinite-scroll base for list tabs
popular_movies_provider.dart     → Popular tab notifier (extends paginated base)
top_rated_movies_provider.dart   → Top Rated tab notifier (extends paginated base)
movie_details_provider.dart      → detail FutureProvider (calls use case)
```

---

# 📋 OpenSpec

OpenSpec change specs live under `openspec/changes/<change-name>/`. They track architecture decisions, requirements, and implementation tasks alongside the code.

- Current change: **`architecture-hardening`** — Clean Architecture, design system, typed errors, and test coverage aligned with the codebase.
- Run `openspec validate architecture-hardening --strict` before marking the change complete (when the OpenSpec CLI is available locally).
- See `AGENTS.md` for the full workflow.

---

# 🧠 Software Engineering Principles

The project applies:

- SOLID Principles
- Clean Code
- Clean Architecture
- Repository Pattern
- Feature First
- Immutable Models
- Dependency Injection
- Single Responsibility Principle
- Spec-Driven Development (OpenSpec — see `openspec/changes/`)

---

# 📦 Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Mobile Framework |
| Dart | Programming Language |
| Riverpod | State Management (flutter_hooks not used) |
| Dio | Networking |
| Freezed | Immutable Models |
| Fluro | Navigation |
| Build Runner | Code Generation |
| Mocktail | Testing mocks |
| dependency_validator | Pubspec dependency hygiene |

---

# 🌐 API

This application consumes data from:

**The Movie Database (TMDB)**

https://developer.themoviedb.org/

Authentication is performed using a Bearer Token generated from TMDB.

---

# 🔄 State Management

Riverpod is used as the application's state management solution.

Application flow:

```text
UI
↓
Provider / Notifier
↓
Use Case
↓
Repository
↓
Datasource
↓
TMDB API
```

---

# 🌍 Navigation

Navigation is managed using **Fluro**, providing centralized route management and better scalability.

---

# 🌐 Networking

Networking is implemented using **Dio**.

Features include:

- Interceptors
- Logging
- Timeouts
- Error Handling
- Retry Strategy

---

# ⚠ Error Handling

The application gracefully handles:

- No Internet Connection
- API Errors
- Timeout Exceptions
- Empty Responses
- Unexpected Exceptions

---

# 🧪 Testing

The testing strategy focuses on business logic.

Current coverage includes:

- Repository
- Providers
- Use Cases
- Data Mapping
- Search Logic
- Design-system widget tests
- Immersive detail widget tests
- Architecture layer boundary tests
- List → detail navigation flow

Future coverage:

- Integration Tests
- Golden Tests

Architecture checks:

```bash
flutter test test/architecture/
dart run dependency_validator
```

---

# ♿ Accessibility

Accessibility considerations include:

- Semantic widgets
- Dynamic text scaling
- Responsive layouts
- Screen reader compatibility

---

# 🚀 Getting Started

## Requirements

Minimum (per technical exercise):

- Flutter **3.35.7+**
- Dart **3.35.7+** (bundled with the Flutter SDK)

This project targets:

- **SDK constraint:** `^3.12.2` in `pubspec.yaml` (Dart shipped with current stable Flutter)
- **Verified locally:** Flutter 3.44.3 · Dart 3.12.2

---

## Installation

Clone the repository

```bash
git clone https://github.com/Esteban37/movie-universe-app.git
```

Navigate to the project

```bash
cd movie-universe-app
```

Install dependencies

```bash
flutter pub get
```

Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application

```bash
flutter run
```

---

# 🔐 Environment Configuration

Environment-specific source files live outside the bundle (gitignored):

- `.env.development` — local development (default)
- `.env.production` — release builds

Only **one** file is bundled in the app: `.env`. Copy the target environment before running or building:

```bash
# Development
cp .env.development.example .env.development
cp .env.development .env
flutter run

# Production (CI or local release)
cp .env.production .env
flutter build apk --release
```

See `.env.example` for all supported variables (`APP_ENV`, `TMDB_BASE_URL`, etc.).

> Secrets are excluded from the repository. CI should generate `.env` from pipeline secrets before `flutter build`.

---

# 📝 Assumptions

- Internet connection is required.
- A valid TMDB API token is required.
- API rate limits are managed by TMDB.
- The project prioritizes scalability over rapid implementation.

---

# 👨‍💻 Author

**Esteban Serrano**

Senior Mobile Software Engineer

---

> **"Software is not only about making things work, but about making them easy to evolve."**

---
