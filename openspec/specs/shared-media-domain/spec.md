## Purpose

Shared domain primitives that unify movies and TV series across features without cross-feature domain coupling. Lives under **`lib/shared/domain/`** (not `core/domain`).

## Requirements

### Requirement: MediaType enumeration
The shared domain SHALL define a `MediaType` enum with values `movie` and `tvShow`.

#### Scenario: MediaType identifies content kind
- **WHEN** a UI or use case needs to branch on content type
- **THEN** it SHALL use `MediaType` instead of string literals or raw TMDB `media_type` strings in presentation

#### Scenario: MediaType location
- **WHEN** inspecting `MediaType`
- **THEN** it SHALL reside under `lib/shared/domain/entities/`

### Requirement: MediaReference identity
A `MediaReference` value object SHALL capture stable cross-feature identity as `(id, MediaType)`.

#### Scenario: Reference without full entity
- **WHEN** navigation, favorites, or cache keys need media identity
- **THEN** the system SHALL use `MediaReference` without loading a full `MovieEntity` or `TvShowEntity`

#### Scenario: MediaReference location
- **WHEN** inspecting `MediaReference`
- **THEN** it SHALL reside under `lib/shared/domain/entities/`

### Requirement: MediaItem sealed union
A Freezed sealed class `MediaItem` SHALL wrap feature-specific entities as a discriminated union.

#### Scenario: MediaItem wraps a movie
- **WHEN** a movie result is represented in cross-feature flows
- **THEN** `MediaItem` SHALL be constructed via `MediaItem.movie(MovieEntity)`

#### Scenario: MediaItem wraps a TV show
- **WHEN** a TV show result is represented in cross-feature flows
- **THEN** `MediaItem` SHALL be constructed via `MediaItem.tvShow(TvShowEntity)`

#### Scenario: MediaItem lives in shared domain
- **WHEN** inspecting `MediaItem`
- **THEN** it SHALL reside under `lib/shared/domain/entities/`
- **AND** feature domain layers SHALL NOT import each other's entity files for search or shared UI mapping

#### Scenario: MediaItem exposes reference
- **WHEN** a `MediaItem` is available
- **THEN** it SHALL expose a `MediaReference` via a convenience accessor (e.g. `reference` getter)

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

### Requirement: Shared domain barrel export
Cross-feature domain types SHALL be exported from a barrel file for stable imports.

#### Scenario: Barrel export
- **WHEN** a feature needs shared media types
- **THEN** it MAY import `lib/shared/domain/shared_domain.dart`
- **AND** that barrel SHALL export `MediaItem`, `MediaType`, and `MediaReference`
