## Purpose

Automated test strategy covering unit, widget, and integration coverage across Clean Architecture layers.
## Requirements
### Requirement: Repository unit tests
The system SHALL have unit tests for all repository implementations.

#### Scenario: Repository returns movies successfully
- **WHEN** the data source returns valid movie data
- **THEN** the repository SHALL return mapped domain entities

#### Scenario: Repository handles data source errors
- **WHEN** the data source throws an exception
- **THEN** the repository SHALL return a failure with the appropriate error

#### Scenario: Network failure throws typed Failure
- **GIVEN** a `DioException` from the data source
- **WHEN** any repository method is invoked
- **THEN** it SHALL throw a `Failure` subtype (not a raw exception)

### Requirement: Provider unit tests
The system SHALL have unit tests for all Riverpod providers.

#### Scenario: Provider emits loading then data
- **WHEN** the provider fetches data
- **THEN** it SHALL emit loading state followed by data state

#### Scenario: Provider handles errors
- **WHEN** the underlying use case/repository fails
- **THEN** the provider SHALL emit an error state

### Requirement: Use case unit tests
The system SHALL have unit tests for all use cases.

#### Scenario: Use case executes repository call
- **WHEN** a use case is invoked
- **THEN** it SHALL call the repository with the correct parameters
- **AND** return the result

#### Scenario: Use-case providers expose domain classes
- **GIVEN** a test container with mocked repositories
- **WHEN** reading `getPopularMoviesProvider` or the search use-case provider (e.g. `searchMediaProvider`)
- **THEN** the result SHALL be the corresponding use-case instance (`GetPopularMovies`, `SearchMedia`, etc.)

### Requirement: Data mapping tests
The system SHALL have tests verifying DTO-to-entity mapping.

#### Scenario: DTO maps to entity correctly
- **WHEN** a DTO is mapped to a domain entity
- **THEN** all fields SHALL be correctly transferred

#### Scenario: DTO handles null fields
- **WHEN** a DTO contains null fields
- **THEN** the mapping SHALL handle nulls with default values

### Requirement: Search logic tests
The system SHALL have tests for search-specific behavior.

#### Scenario: Search with empty query
- **WHEN** the user submits an empty search query
- **THEN** the system SHALL NOT make an API request

### Requirement: Shared test fixtures
The test suite SHALL provide reusable fixture factories for DTOs and entities.

#### Scenario: Sample movie DTO factory
- **WHEN** a test needs a MovieDTO
- **THEN** a factory method SHALL provide a sample instance with realistic default values

#### Scenario: Sample movie entity factory
- **WHEN** a test needs a MovieEntity
- **THEN** a factory method SHALL provide a sample entity with default values

### Requirement: Provider override utilities
Tests SHALL support Riverpod provider overrides for isolated testing.

#### Scenario: ProviderContainer with overrides
- **WHEN** testing a provider
- **THEN** a ProviderContainer SHALL be created with overridden dependencies

#### Scenario: Widget tests override repository provider
- **WHEN** a widget or provider test needs isolated data access
- **THEN** it SHALL override `movieRepositoryProvider` or use-case providers
- **AND** it SHALL NOT instantiate repository implementations directly

### Requirement: Static analysis passes
The project SHALL pass dart analyze with zero errors and warnings.

#### Scenario: dart analyze passes
- **WHEN** `dart analyze` is run
- **THEN** it SHALL report no errors or warnings

### Requirement: All tests pass
The full test suite SHALL pass without failures.

#### Scenario: flutter test passes
- **WHEN** `flutter test` is run
- **THEN** all tests SHALL pass with zero failures

### Requirement: Architecture-aligned automated test coverage
After architecture-hardening refactors, the automated test suite SHALL validate structural changes while preserving existing product and premium-UI behavioral coverage.

#### Scenario: Use-case wiring is verifiable
- **WHEN** presentation providers fetch movie data through the refactored stack
- **THEN** automated tests SHALL verify data flows through use cases rather than direct repository access from providers

#### Scenario: Typed failures surface in UI
- **WHEN** a screen or shared async-state widget renders an error backed by a typed `Failure`
- **THEN** automated tests SHALL assert the user-facing message is displayed
- **AND** raw exception type strings (e.g. `Instance of '…'`) SHALL NOT appear

#### Scenario: Primary navigation flows remain covered
- **WHEN** routing or list/detail presentation is refactored
- **THEN** automated tests SHALL verify that navigating from a list entry to its detail view still works

#### Scenario: Scroll-driven behaviors remain covered
- **WHEN** paginated lists or scrollable detail screens are refactored
- **THEN** automated tests SHALL verify scroll-triggered behaviors such as loading the next page or collapsing immersive headers

#### Scenario: Cross-cutting helpers have focused unit tests
- **WHEN** shared infrastructure is introduced or refactored (e.g. image URL builders, failure mappers)
- **THEN** it SHALL have unit tests that validate behavior independently of full widget trees

#### Scenario: Reusable UI components are testable in isolation
- **WHEN** design-system or shared widgets are added or migrated
- **THEN** they SHALL have widget tests that exercise rendering without assembling entire screens

#### Scenario: Test updates follow architecture changes
- **WHEN** an architecture refactor changes error handling, provider wiring, or shared helpers
- **THEN** existing tests SHALL be updated to reflect the new contracts
- **AND** new tests SHALL be added only where coverage gaps are identified — not as one-off duplicates of product requirements already covered elsewhere

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

### Requirement: Integration test coverage
The project SHALL include integration tests for primary shell navigation flows using offline mocks.

#### Scenario: Tab navigation to detail
- **WHEN** `flutter test integration_test` is run
- **THEN** tests SHALL verify Movies, Series, and Search tabs can navigate from list to detail
- **AND** tests SHALL use `integration_test/helpers/navigation_harness.dart` for offline AppShell setup

### Requirement: Continuous integration pipeline
The repository SHALL run automated quality gates on push and pull request to main integration branches.

#### Scenario: CI workflow steps
- **WHEN** GitHub Actions CI runs (`.github/workflows/ci.yml`)
- **THEN** it SHALL execute `dart analyze --fatal-warnings`
- **AND** `dart run dependency_validator`
- **AND** `flutter test`
- **AND** `flutter test integration_test`

