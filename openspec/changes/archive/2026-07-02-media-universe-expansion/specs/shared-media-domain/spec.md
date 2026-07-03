## Purpose

Shared domain primitives that unify movies and TV series across features without cross-feature domain coupling.

## ADDED Requirements

### Requirement: MediaType enumeration
The core domain SHALL define a `MediaType` enum with values `movie` and `tvShow`.

#### Scenario: MediaType identifies content kind
- **WHEN** a UI or use case needs to branch on content type
- **THEN** it SHALL use `MediaType` instead of string literals or TMDB `media_type` strings in presentation

### Requirement: MediaItem sealed union
A Freezed sealed class `MediaItem` SHALL wrap feature-specific entities as a discriminated union.

#### Scenario: MediaItem wraps a movie
- **WHEN** a movie result is represented in cross-feature flows
- **THEN** `MediaItem` SHALL be constructed via `MediaItem.movie(MovieEntity)`

#### Scenario: MediaItem wraps a TV show
- **WHEN** a TV show result is represented in cross-feature flows
- **THEN** `MediaItem` SHALL be constructed via `MediaItem.tvShow(TvShowEntity)`

#### Scenario: MediaItem lives in core domain
- **WHEN** inspecting `MediaItem`
- **THEN** it SHALL reside under `lib/core/domain/entities/`
- **AND** feature domain layers SHALL NOT import each other's entity files for search or shared UI mapping

### Requirement: MediaItem identity accessors
`MediaItem` SHALL expose id, title, posterPath, voteAverage, and mediaType regardless of variant.

#### Scenario: Unified list rendering
- **WHEN** a widget receives a `MediaItem`
- **THEN** it SHALL be able to read id, title, posterPath, voteAverage, and mediaType without casting to feature entities

### Requirement: Cross-feature domain isolation
The movies domain SHALL NOT import the tv_shows domain and vice versa.

#### Scenario: Movies domain imports
- **WHEN** scanning `lib/features/movies/domain/`
- **THEN** no imports reference `features/tv_shows/domain`

#### Scenario: TV shows domain imports
- **WHEN** scanning `lib/features/tv_shows/domain/`
- **THEN** no imports reference `features/movies/domain`
