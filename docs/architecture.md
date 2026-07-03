# Architecture

Movie Universe follows **Clean Architecture** with a **feature-first** layout. **`AGENTS.md`** is the authoritative reference for engineering conventions and AI-assisted tooling.

---

## Principles

- SOLID, Clean Code, Repository Pattern
- Feature-first modules (`features/<name>/{data,domain,presentation}/`)
- Immutable models (Freezed)
- Dependency injection (Riverpod)
- Spec-driven development ([openspec.md](openspec.md))

---

## Layer model

```text
┌─────────────────────────────────────────────────────────┐
│  Presentation (features/*/presentation, shared/presentation) │
│  Screens, widgets, Riverpod providers/notifiers              │
└───────────────────────────┬─────────────────────────────┘
                            │ use cases only
┌───────────────────────────▼─────────────────────────────┐
│  Domain (features/*/domain, shared/domain)               │
│  Entities, repository contracts, use cases               │
└───────────────────────────┬─────────────────────────────┘
                            │ contracts
┌───────────────────────────▼─────────────────────────────┐
│  Data (features/*/data, core/data)                       │
│  DTOs, mappers, remote datasources, repository impls     │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│  Core + TMDB API                                         │
└─────────────────────────────────────────────────────────┘
```

### Rules (enforced in `test/architecture/layer_boundaries_test.dart`)

1. **Domain isolation** — `domain/` must not import `data/` or `presentation/`.
2. **Use-case wiring** — UI providers call use-case providers, not repository providers directly.
3. **Cross-feature decoupling** — search data must not import movies data; movies/tv_shows domain and presentation must not cross-import.
4. **Design-system independence** — `lib/shared/design_system/` must not import feature modules.
5. **Core domain** — if present under `lib/core/domain/`, must not import features.
6. **Shared media domain** — cross-feature primitives live in `lib/shared/domain/`, not `core/`.

---

## Project structure

```text
lib/

├── core/
│   ├── config/        # EnvironmentConfig, .env wiring
│   ├── constants/
│   ├── data/          # Shared DTOs & mappers (TmdbMovieDto, TmdbTvShowDto)
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
│   │           ├── popular_movies_provider.dart
│   │           ├── top_rated_movies_provider.dart
│   │           └── movie_details_provider.dart
│   ├── search/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── providers/
│   │           ├── search_repository_provider.dart
│   │           ├── search_usecase_providers.dart
│   │           └── search_provider.dart
│   └── tv_shows/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           └── providers/
│               ├── tv_show_repository_provider.dart
│               ├── tv_show_usecase_providers.dart
│               ├── popular_tv_shows_provider.dart
│               ├── top_rated_tv_shows_provider.dart
│               └── tv_show_details_provider.dart
│
├── shared/
│   ├── domain/            # MediaItem, MediaType, MediaReference
│   ├── design_system/     # atoms, molecules, models, templates
│   ├── mappers/
│   ├── presentation/
│   │   ├── detail/        # ImmersiveDetailViewTemplate
│   │   ├── providers/     # PaginatedMediaNotifier<T>
│   │   └── shell/         # AppShell, primary tab app bar
│   └── widgets/           # Premium shared widgets (barrel re-exports)
│
└── main.dart
```

---

## Provider wiring

```text
# Shared pagination (lib/shared/presentation/providers/)
paginated_media_notifier.dart  → PaginatedMediaNotifier<T> base for infinite-scroll tabs

# Movies
movie_repository_provider.dart   → MovieRepository (DI only)
movie_usecase_providers.dart     → GetPopularMovies, GetTopRatedMovies, GetMovieDetails
popular_movies_provider.dart     → PaginatedMediaNotifier<MovieEntity> (Popular)
top_rated_movies_provider.dart   → PaginatedMediaNotifier<MovieEntity> (Top Rated)
movie_details_provider.dart      → FutureProvider → GetMovieDetails

# TV Shows
tv_show_repository_provider.dart → TvShowRepository (DI only)
tv_show_usecase_providers.dart   → GetPopularTvShows, GetTopRatedTvShows, GetTvShowDetails
popular_tv_shows_provider.dart   → PaginatedMediaNotifier<TvShowEntity> (Popular)
top_rated_tv_shows_provider.dart → PaginatedMediaNotifier<TvShowEntity> (Top Rated)
tv_show_details_provider.dart    → FutureProvider → GetTvShowDetails

# Search (unified multi)
search_repository_provider.dart  → SearchRepository (DI only)
search_usecase_providers.dart    → searchMediaProvider (SearchMedia use case)
search_provider.dart             → PaginatedSearchNotifier → searchMediaProvider
```

Runtime flow (API, errors, Riverpod): [runtime-design.md](runtime-design.md).

---

## Feature modules

| Feature | Responsibility |
|---------|----------------|
| `movies` | Popular / top-rated lists, movie detail |
| `tv_shows` | Popular / top-rated series lists, TV detail |
| `search` | Unified multi search with filter chips and pagination |

---

## Shared layer

| Path | Role |
|------|------|
| `shared/domain/` | Cross-feature primitives: `MediaItem`, `MediaType`, `MediaReference` |
| `shared/design_system/` | Atomic-design UI (atoms, molecules, models, templates) |
| `shared/presentation/` | `AppShell`, `PaginatedMediaNotifier<T>`, `ImmersiveDetailViewTemplate` |
| `shared/mappers/` | Entity → `MediaDisplayModel` mapping |
| `shared/widgets/` | Premium widgets (`hero_backdrop`, `content_state`, `skeleton_loader`) |

**Why `shared/domain`?** Search returns `List<MediaItem>` without coupling search domain to movies or tv_shows entities. `MediaReference` provides stable identity for favorites, deep links, and offline snapshots ([roadmap.md](roadmap.md)).

---

## Core layer

| Path | Role |
|------|------|
| `core/config/` | Environment and `.env` wiring |
| `core/data/` | Shared TMDB DTOs and mappers |
| `core/network/` | Dio client, interceptors, retry |
| `core/router/` | Fluro routes; immersive detail transitions |
| `core/errors/` | Typed `Failure` hierarchy |
| `core/media/` | `TmdbImageUrl` |
| `core/theme/` | Dark/light cinematic palette |

---

## Design system

Organized by atomic design under `lib/shared/design_system/`:

- **atoms** — `RatingBadge`, `PosterImage`, `BackdropImage`, `GenreChip`, `ErrorView`, …
- **molecules** — `MediaCard`, `MovieCard`, `MediaMetaRow`
- **models** — `MediaDisplayModel` (UI-facing, no feature entity imports)
- **templates** — `ImmersiveDetailHeaderDelegate` (collapsing header shared by movie/TV detail)

Feature detail screens delegate scroll, parallax, swipe-to-dismiss, and poster cross-fade to **`ImmersiveDetailViewTemplate`**.

---

## Scalability patterns

| Pattern | Location | Benefit |
|---------|----------|---------|
| `PaginatedMediaNotifier<T>` | `shared/presentation/providers/` | One pagination base for all list tabs |
| `ImmersiveDetailViewTemplate` | `shared/presentation/detail/` | Premium detail UX without duplicating scroll math |
| `MediaItem` union | `shared/domain/` | Unified search and future cross-media features |
| Shared TMDB DTOs | `core/data/` | Search does not import movies data layer |
| Feature-first modules | `features/*` | Add screens without touching unrelated code |

Planned extensions: [roadmap.md](roadmap.md).

---

## Testing & CI

See [testing-strategy.md](testing-strategy.md) — unit/widget/integration tests, architecture boundary tests, GitHub Actions.

---

## Related documents

| Document | Purpose |
|----------|---------|
| [README.md](../README.md) | Project overview, setup, AI usage |
| [runtime-design.md](runtime-design.md) | API, networking, state, errors |
| [openspec.md](openspec.md) | OpenSpec workflow |
| [AGENTS.md](../AGENTS.md) | Engineering guardrails |
| `openspec/specs/` | Baseline capability specifications |
