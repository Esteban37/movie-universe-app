# Architecture Hardening — Tasks

## Clean Architecture & features

- [x] Feature-first layout: `movies/`, `search/` with data/domain/presentation
- [x] Use cases for all presentation data flows
- [x] Repository providers separate from use-case providers
- [x] Shared `TmdbMovieDto` + `TmdbMovieMapper` in `core/data/`
- [x] `PaginatedMoviesNotifier` for Popular / Top Rated tabs

## Design system

- [x] Atoms: RatingBadge, PosterImage, BackdropImage, GenreChip, ErrorView, LoadingView, EmptyView
- [x] Molecules: MovieCard, SearchResultCard, MovieMetaRow
- [x] Models: `MovieDisplayModel`
- [x] Barrel re-exports in `shared/widgets/` for loading/empty/error
- [x] GenreChip used in immersive detail content

## Error handling & media

- [x] Sealed `Failure` hierarchy + `mapDioExceptionToFailure`
- [x] `failureUserMessage` / `ErrorView.failure` in all async screens
- [x] `TmdbImageUrl` — no hardcoded TMDB URLs in widgets

## Testing

- [x] Unit tests: repositories, use cases, DTOs, mappers
- [x] Provider tests with `movieRepositoryProvider` override seam
- [x] Widget tests: design system, list→detail navigation, scroll pagination
- [x] Immersive detail widget tests
- [x] `test/architecture/layer_boundaries_test.dart`
- [x] `dependency_validator` in dev_dependencies

## Documentation

- [x] `AGENTS.md` aligned with codebase conventions
- [x] `README.md` structure, providers, OpenSpec section
- [x] OpenSpec change specs under `openspec/changes/architecture-hardening/`

## Deferred

- [ ] TV Shows / Series feature module
- [ ] Search result pagination on scroll
- [ ] Integration / golden tests
- [ ] OpenSpec CLI validation in CI
