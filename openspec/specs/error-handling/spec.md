## Purpose

Centralized error handling from network/data layers through typed failures to user-facing presentation messages.
## Requirements
### Requirement: Handle no internet connection
The system SHALL gracefully handle scenarios when there is no internet connection.

#### Scenario: No internet during API request
- **WHEN** an API request fails due to no internet connection
- **THEN** the system SHALL display a "No internet connection" message
- **AND** provide a retry button

### Requirement: Handle API errors
The system SHALL gracefully handle API errors returned by TMDB.

#### Scenario: API returns an error status code
- **WHEN** the TMDB API returns a non-200 status code
- **THEN** the system SHALL display a user-friendly error message
- **AND** log the technical error details

### Requirement: Handle timeout errors
The system SHALL handle request timeout exceptions.

#### Scenario: API request times out
- **WHEN** an API request exceeds the configured timeout
- **THEN** the system SHALL display a timeout error message
- **AND** provide a retry option

### Requirement: Handle unexpected exceptions
The system SHALL catch unexpected exceptions without crashing.

#### Scenario: Unexpected exception occurs
- **WHEN** an unexpected exception occurs during any operation
- **THEN** the system SHALL display a generic error message
- **AND** NOT crash the application

### Requirement: Typed failure hierarchy
The project SHALL have a sealed Failure class with typed subtypes.

#### Scenario: Network failure
- **WHEN** a network error occurs (no internet, DNS failure)
- **THEN** the system SHALL return a `NetworkFailure` with a user-friendly message

#### Scenario: Server failure
- **WHEN** the API returns a 5xx status code
- **THEN** the system SHALL return a `ServerFailure` with the status code

#### Scenario: Timeout failure
- **WHEN** a request times out
- **THEN** the system SHALL return a `TimeoutFailure`

#### Scenario: Unexpected failure
- **WHEN** an unknown exception occurs
- **THEN** the system SHALL return an `UnexpectedFailure` with the error details

### Requirement: Typed failures surfaced to the presentation layer
The presentation layer SHALL render the user-facing message from the typed `Failure` produced by the data layer, rather than a raw exception string.

#### Scenario: Provider propagates a typed failure
- **WHEN** a repository or use case throws a `Failure`
- **THEN** the provider SHALL expose that `Failure` as its async error state
- **AND** the `Failure` subtype SHALL be preserved (not converted to a generic `Exception`)

#### Scenario: Error view shows the failure message
- **WHEN** a screen renders an error state backed by a `Failure`
- **THEN** it SHALL display `Failure.message` (e.g., "No internet connection")
- **AND** it SHALL NOT display a raw `toString()` such as `Instance of 'NetworkFailure'`

#### Scenario: Failure mapped via exhaustive pattern matching
- **WHEN** the presentation layer converts a `Failure` into a display message
- **THEN** it SHALL use exhaustive `sealed` pattern matching over the `Failure` subtypes
- **AND** each subtype (Network, Server, Timeout, Unexpected) SHALL map to its user-friendly message

