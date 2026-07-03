## Requirements

### Requirement: Centralized HTTP client
The system SHALL provide a centralized Dio HTTP client for all TMDB API requests.

#### Scenario: HTTP client is configured
- **WHEN** the application starts
- **THEN** a Dio instance SHALL be configured with base URL (api.themoviedb.org/3)
- **AND** default headers SHALL include the Authorization Bearer token

### Requirement: Request interception
The system SHALL use Dio interceptors for cross-cutting concerns.

#### Scenario: Auth interceptor adds token
- **WHEN** any API request is made
- **THEN** the auth interceptor SHALL attach the Bearer token to the request headers

#### Scenario: Logging interceptor logs requests
- **WHEN** an API request is made or a response is received
- **THEN** the logging interceptor SHALL log the request method, URL, status code, and duration

#### Scenario: Retry interceptor on failure
- **WHEN** an API request fails due to a transient error
- **THEN** the retry interceptor SHALL retry the request with exponential backoff (up to 3 retries)

### Requirement: Request timeout
The system SHALL enforce timeouts on all API requests.

#### Scenario: Request exceeds timeout
- **WHEN** an API request takes longer than the configured timeout (30 seconds)
- **THEN** the system SHALL cancel the request and throw a timeout exception
