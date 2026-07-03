## ADDED Requirements

### Requirement: Layer boundary automated tests

`test/architecture/layer_boundaries_test.dart` MUST pass on every structural refactor.

#### Scenario: Layer boundaries verified
- **WHEN** `flutter test test/architecture/` is run
- **THEN** all layer-boundary rules (domain isolation, use-case wiring, cross-feature decoupling, design-system independence) SHALL pass

### Requirement: Dependency graph validation

The project SHALL enforce package dependency rules via `dependency_validator`.

#### Scenario: dependency_validator passes
- **WHEN** `dart run dependency_validator` is run
- **THEN** it SHALL report no dependency violations

### Requirement: Network failure throws typed Failure

Repository implementations MUST map DTOs to domain entities and throw typed `Failure` on network errors.

#### Scenario: Network failure throws typed Failure
- **GIVEN** a `DioException` from the data source
- **WHEN** any repository method is invoked
- **THEN** it SHALL throw a `Failure` subtype (not a raw exception)

### Requirement: Use-case provider wiring tests

Use-case providers MUST expose domain use case classes wired to repository providers.

#### Scenario: Use-case providers expose domain classes
- **GIVEN** a test container with mocked repositories
- **WHEN** reading `getPopularMoviesProvider` or the search use-case provider
- **THEN** the result SHALL be the corresponding use-case instance

### Requirement: Widget test provider override seam

Widget and provider tests MUST override `movieRepositoryProvider` (or use-case providers) — not instantiate repositories directly.

#### Scenario: Widget tests override repository provider
- **WHEN** a widget or provider test needs isolated data access
- **THEN** it SHALL override `movieRepositoryProvider` or use-case providers
- **AND** it SHALL NOT instantiate repository implementations directly
