## ADDED Requirements

### Requirement: Feature-first modules

Each feature MUST live under `lib/features/<name>/{data,domain,presentation}/`.

#### Scenario: Movies feature layout
- **GIVEN** the movies feature
- **WHEN** inspecting `lib/features/movies/`
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
- **THEN** it reads the search use-case provider, not `searchRepositoryProvider`

#### Scenario: Popular movies provider
- **GIVEN** `popular_movies_provider.dart`
- **WHEN** fetching a page
- **THEN** it reads `getPopularMoviesProvider`

### Requirement: Cross-feature data decoupling

Search data layer MUST NOT import movies data layer.

#### Scenario: Search DTOs
- **GIVEN** `lib/features/search/data/`
- **WHEN** scanning imports
- **THEN** no imports reference `features/movies/data`

### Requirement: Design system independence

Design-system widgets MUST NOT import feature layers.

#### Scenario: MovieCard
- **GIVEN** `lib/shared/design_system/molecules/movie_card.dart`
- **WHEN** inspecting imports
- **THEN** it uses `MovieDisplayModel`, not `MovieEntity`

### Requirement: Layer boundary verification

Structural refactors MUST keep automated layer-boundary tests passing.

#### Scenario: Architecture tests pass
- **WHEN** `flutter test test/architecture/` is run
- **THEN** all layer-boundary tests pass with zero failures
