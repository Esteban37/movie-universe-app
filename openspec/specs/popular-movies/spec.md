## Requirements

### Requirement: Browse popular movies
The system SHALL display a paginated list of currently popular movies fetched from the TMDB API.

#### Scenario: Load popular movies on app start
- **WHEN** the user opens the app
- **THEN** the system SHALL load the first page of popular movies from TMDB
- **AND** display them in a vertical scrollable list

#### Scenario: Loading state while fetching popular movies
- **WHEN** the system is fetching popular movies
- **THEN** the system SHALL show a loading indicator

#### Scenario: Display popular movie card
- **WHEN** popular movies are loaded
- **THEN** each movie card SHALL display the poster image, title, and rating

#### Scenario: Error state when popular movies fail to load
- **WHEN** the popular movies request fails (network error, timeout, API error)
- **THEN** the system SHALL display an error message with a retry button

#### Scenario: Empty state when no popular movies available
- **WHEN** the popular movies API returns an empty list
- **THEN** the system SHALL display an empty state message
