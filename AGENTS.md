# Movie Universe — Agent Guidelines

Engineering guardrails for AI-assisted and manual development. These rules apply to all new code and refactors.

## Architecture

- Follow **Clean Architecture** with feature-first layout: `features/<feature>/{data,domain,presentation}/`.
- **Presentation providers MUST call use cases**, not repositories directly (except repository provider wiring).
- Domain layer MUST NOT depend on data or presentation types.
- Shared TMDB list-item DTOs live in `lib/core/data/dtos/` (`TmdbMovieDto`, `TmdbTvShowDto`) with mapping in `lib/core/data/mappers/`.
- Cross-feature domain primitives (`MediaItem`, `MediaType`, `MediaReference`) live in `lib/shared/domain/` — not in `core/`.
- Shared presentation templates: `ImmersiveDetailViewTemplate` (scroll/dismiss), `ImmersiveDetailHeaderDelegate` (collapsing header slot).
- `PaginatedMediaNotifier<T>` in `lib/shared/presentation/providers/` for infinite-scroll list tabs.
- Design-system widgets MUST NOT import feature layers; use `MediaDisplayModel` / `MovieDisplayModel` in `lib/shared/design_system/models/`.

### Provider wiring (features)

Repository providers wire DI only; use-case providers expose domain operations; UI notifiers/screens consume use cases.

```text
# Shared pagination base (lib/shared/presentation/providers/)
paginated_media_notifier.dart  → PaginatedMediaNotifier<T> for infinite-scroll list tabs

# Movies
movie_repository_provider.dart   → MovieRepository
movie_usecase_providers.dart     → GetPopularMovies, GetTopRatedMovies, GetMovieDetails
popular_movies_provider.dart     → PaginatedMediaNotifier<MovieEntity> (Popular)
top_rated_movies_provider.dart   → PaginatedMediaNotifier<MovieEntity> (Top Rated)
movie_details_provider.dart      → FutureProvider → GetMovieDetails

# TV Shows
tv_show_repository_provider.dart → TvShowRepository
tv_show_usecase_providers.dart   → GetPopularTvShows, GetTopRatedTvShows, GetTvShowDetails
popular_tv_shows_provider.dart   → PaginatedMediaNotifier<TvShowEntity> (Popular)
top_rated_tv_shows_provider.dart → PaginatedMediaNotifier<TvShowEntity> (Top Rated)
tv_show_details_provider.dart    → FutureProvider → GetTvShowDetails

# Search (unified multi)
search_repository_provider.dart  → SearchRepository
search_usecase_providers.dart    → searchMediaProvider (SearchMedia)
search_provider.dart             → PaginatedSearchNotifier → searchMediaProvider
```

## Design System (Atomic Design)

- Place **shared, reusable** UI in `lib/shared/design_system/`:
  - `atoms/` — primitive widgets (RatingBadge, PosterImage, BackdropImage, GenreChip, ErrorView, …)
  - `molecules/` — composed widgets (MediaCard, MovieCard, MediaMetaRow)
  - `models/` — feature-agnostic display models (`MediaDisplayModel`, `MovieDisplayModel`)
  - `organisms/` / `templates/` — screen sections when extracted incrementally (e.g. `ImmersiveDetailHeaderDelegate`)
- `lib/shared/widgets/` holds premium shared widgets (`hero_backdrop`, `content_state`, `skeleton_loader`) from `premium-ui-redesign`; design-system atoms MAY re-export or wrap them via `shared/widgets/` barrels (e.g. `error_view.dart`, `loading_view.dart`, `empty_view.dart`).
- **Do NOT simplify or replace premium UI** during architecture refactors (see Visual Preservation below).

## Visual Preservation (`premium-ui-redesign`)

Architecture refactors MUST preserve the visual source of truth on branch `feat/premium-ui-redesign`:

- **Theme:** dark/light modes via `themeModeProvider`, cinematic palette in `AppTheme.dark()` / `AppTheme.light()`
- **Navigation:** `AppRouter.pushMovieDetail` / `AppRouter.pushTvShowDetail` with `opaque: false` + fade transition
- **Immersive detail:** collapsing header, parallax, poster cross-fade, swipe-to-dismiss, scroll animations — shared behavior in `ImmersiveDetailViewTemplate` (`lib/shared/presentation/detail/`); feature modules supply header/content slivers
- **Shared widgets:** `hero_backdrop.dart`, `content_state.dart`, `skeleton_loader.dart` must stay in the render tree
- **Media atoms:** use `PosterImage` / `BackdropImage` instead of raw `Image.network` for TMDB assets
- **Genres in detail:** use design-system `GenreChip` (not raw `Chip`) in `DetailContent`

When applying architecture patterns (use cases, typed errors, `TmdbImageUrl`), patch in-place — never swap premium screens for simplified placeholders.

## Theming & Media

- **No hardcoded colors** in widgets — use `Theme.of(context).colorScheme` / `textTheme` tokens.
  - Exception: semantically neutral values like `Colors.transparent` for gradient endpoints.
- **No hardcoded TMDB image URLs** — use `core/media/tmdb_image.dart` (`TmdbImageUrl`).

## Error Handling

- Data layer throws typed `Failure` subtypes from `core/errors/failures.dart`.
- Presentation layer MUST surface `Failure.message` to users (via `ErrorView.failure` or `failureUserMessage`), never raw `error.toString()`.

## Testing

- Add tests alongside implementation (unit tests for logic, widget tests for design-system components).
- Keep existing screen/navigation tests green when refactoring structure.
- Preserve `movieRepositoryProvider` override seam in widget/provider tests.
- Run `test/architecture/layer_boundaries_test.dart` after structural refactors.
- Run `dart run dependency_validator` to keep pubspec dependencies clean.
- Run `flutter test integration_test` for shell navigation flows (Movies, Series, Search → detail).

## OpenSpec Workflow

Change specs live under `openspec/changes/<change-name>/`. **There is no active change** — recent work is archived under `openspec/changes/archive/` (e.g. `architecture-hardening`, `media-universe-expansion`).

- Main (baseline) specs live under `openspec/specs/` (versioned in Git).
- New work: create a change with OpenSpec, implement, sync deltas (`/opsx-sync`), then archive (`/opsx-archive`).
- Run `openspec validate <change> --strict` before marking a change complete.
- Implementation tasks are tracked in `tasks.md` with `- [ ]` / `- [x]` checkboxes.

Treat `AGENTS.md`, `README.md`, `docs/` (see `docs/README.md`), and `openspec/specs/` as the living architecture reference.
