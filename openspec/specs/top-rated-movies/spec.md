## Requirements

### Requirement: Browse top-rated movies
The system SHALL display a paginated list of top-rated movies fetched from the TMDB API.

#### Scenario: Navigate to top-rated movies tab
- **WHEN** the user navigates to the top-rated movies tab
- **THEN** the system SHALL load the first page of top-rated movies from TMDB

#### Scenario: Loading state while fetching top-rated movies
- **WHEN** the system is fetching top-rated movies
- **THEN** the system SHALL show a loading indicator

#### Scenario: Display top-rated movie card
- **WHEN** top-rated movies are loaded
- **THEN** each movie card SHALL display the poster image, title, and rating

#### Scenario: Error state when top-rated movies fail to load
- **WHEN** the top-rated movies request fails
- **THEN** the system SHALL display an error message with a retry button
