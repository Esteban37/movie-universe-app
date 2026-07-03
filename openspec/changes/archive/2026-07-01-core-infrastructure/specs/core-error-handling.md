## ADDED Requirements

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
