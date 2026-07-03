## ADDED Requirements

### Requirement: Movie details provider
A provider SHALL fetch and expose movie details by movie ID.

#### Scenario: Provider loads details by ID
- **WHEN** a movie ID is provided
- **THEN** the provider SHALL fetch movie details from the repository
- **AND** emit loading then data state

#### Scenario: Provider handles errors
- **WHEN** the movie details request fails
- **THEN** the provider SHALL emit an error state

### Requirement: Movie details screen
A screen SHALL display full movie details with backdrop, poster, and metadata.

#### Scenario: Screen shows loading indicator
- **WHEN** movie details are being fetched
- **THEN** the screen SHALL show the LoadingView

#### Scenario: Screen displays movie detail
- **WHEN** movie details are loaded
- **THEN** the screen SHALL display backdrop image, poster, title, release date, vote average, genres, overview, and runtime

#### Scenario: Screen shows error with retry
- **WHEN** movie details fail to load
- **THEN** the screen SHALL show the ErrorView with retry
