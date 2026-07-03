## Requirements

### Requirement: View movie details
The system SHALL display detailed information about a selected movie.

#### Scenario: Navigate to movie details screen
- **WHEN** the user taps on a movie card
- **THEN** the system SHALL navigate to the movie details screen
- **AND** display the movie's backdrop image, poster, title, release date, rating, overview, and genres

#### Scenario: Loading state for movie details
- **WHEN** the system is fetching movie details from TMDB
- **THEN** the system SHALL show a loading indicator

#### Scenario: Error state for movie details
- **WHEN** the movie details request fails
- **THEN** the system SHALL display an error message with a retry button
