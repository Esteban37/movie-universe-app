## ADDED Requirements

### Requirement: Centralized HTTP client
The project SHALL provide a Dio-based HTTP client configured for TMDB API.

#### Scenario: Dio client configured
- **WHEN** the application initializes
- **THEN** a Dio instance SHALL exist with base URL `https://api.themoviedb.org/3` and Bearer token auth

#### Scenario: Auth interceptor attaches token
- **WHEN** any API request is made
- **THEN** the auth interceptor SHALL inject the Bearer token into request headers

#### Scenario: Logging interceptor logs requests and responses
- **WHEN** an API request completes or fails
- **THEN** the logging interceptor SHALL log method, URL, status code, and duration

#### Scenario: Retry interceptor handles transient failures
- **WHEN** a GET request fails with a transient error
- **THEN** the retry interceptor SHALL retry up to 3 times with exponential backoff

#### Scenario: Request timeout enforced
- **WHEN** an API request exceeds 30 seconds
- **THEN** Dio SHALL throw a timeout exception
