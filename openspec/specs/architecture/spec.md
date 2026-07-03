## Purpose

Cross-cutting Clean Architecture layer boundaries: feature-first modules, domain isolation, use-case wiring in presentation, cross-feature decoupling, and design-system independence. Verified by `test/architecture/layer_boundaries_test.dart`.

## Requirements

### Requirement: Feature-first modules

Each feature MUST live under `lib/features/<name>/{data,domain,presentation}/`.

#### Scenario: Movies feature layout
- **GIVEN** the movies feature
- **WHEN** inspecting `lib/features/movies/`
- **THEN** `data/`, `domain/`, and `presentation/` directories exist

#### Scenario: TV shows feature layout
- **GIVEN** the tv_shows feature
- **WHEN** inspecting `lib/features/tv_shows/`
- **THEN** `data/`, `domain/`, and `presentation/` directories exist

### Requirement: Domain isolation

The domain layer MUST NOT import from `data/` or `presentation/`.

#### Scenario: Domain imports
- **GIVEN** any file under `lib/features/*/domain/`
- **WHEN** scanning import statements
- **THEN** no imports reference `/data/` or `/presentation/`

### Requirement: Presentation calls use cases

UI notifiers and FutureProviders MUST call use cases, not repositories directly.

#### Scenario: Search provider
- **GIVEN** `search_provider.dart`
- **WHEN** performing a search
- **THEN** it reads the search use-case provider (e.g. `searchMediaProvider`), not `searchRepositoryProvider`

#### Scenario: Popular movies provider
- **GIVEN** `popular_movies_provider.dart`
- **WHEN** fetching a page
- **THEN** it reads `getPopularMoviesProvider`

#### Scenario: Popular TV provider
- **GIVEN** `popular_tv_shows_provider.dart`
- **WHEN** fetching a page
- **THEN** it reads `getPopularTvShowsProvider`

### Requirement: Cross-feature data decoupling

Search data layer MUST NOT import movies data layer.

#### Scenario: Search DTOs
- **GIVEN** `lib/features/search/data/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/data`

#### Scenario: TV data imports
- **GIVEN** `lib/features/tv_shows/data/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/data`

### Requirement: Cross-feature domain decoupling

Movies and TV shows domain layers MUST NOT cross-import.

#### Scenario: Movies domain imports
- **GIVEN** `lib/features/movies/domain/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/tv_shows/domain`

#### Scenario: TV domain imports
- **GIVEN** `lib/features/tv_shows/domain/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/domain`

#### Scenario: Search domain decoupled from movies
- **GIVEN** `lib/features/search/domain/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/domain/entities/movie_entity.dart`

### Requirement: Cross-feature presentation decoupling

Movies and TV shows presentation layers MUST NOT cross-import.

#### Scenario: Movies presentation imports
- **GIVEN** `lib/features/movies/presentation/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/tv_shows/presentation`

#### Scenario: TV presentation imports
- **GIVEN** `lib/features/tv_shows/presentation/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/presentation`

### Requirement: Design system independence

Design-system widgets MUST NOT import feature layers.

#### Scenario: MediaCard
- **GIVEN** `lib/shared/design_system/molecules/media_card.dart`
- **WHEN** inspecting imports
- **THEN** it uses `MediaDisplayModel`, not feature domain entities

#### Scenario: Design system scan
- **GIVEN** `lib/shared/design_system/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/`

### Requirement: Layer boundary verification

Structural refactors MUST keep automated layer-boundary tests passing.

#### Scenario: Architecture tests pass
- **WHEN** `flutter test test/architecture/` is run
- **THEN** all layer-boundary tests pass with zero failures

### Requirement: Shared presentation templates
Immersive detail scroll, parallax, and swipe-to-dismiss behavior SHALL be shared across movie and TV detail features.

#### Scenario: ImmersiveDetailViewTemplate
- **WHEN** a movie or TV immersive detail screen is implemented
- **THEN** scroll/dismiss/parallax behavior SHALL delegate to `ImmersiveDetailViewTemplate` under `lib/shared/presentation/detail/`
- **AND** feature modules SHALL supply header and content slivers only

#### Scenario: ImmersiveDetailHeaderDelegate
- **WHEN** a collapsing detail header is implemented
- **THEN** feature-specific header delegates SHALL compose `ImmersiveDetailHeaderDelegate` from `lib/shared/design_system/templates/`

### Requirement: Core domain must not depend on features
If `lib/core/domain/` exists, it MUST NOT import feature modules.

#### Scenario: Core domain isolation
- **GIVEN** any file under `lib/core/domain/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/`
- **AND** cross-feature media primitives SHALL live in `lib/shared/domain/` instead
