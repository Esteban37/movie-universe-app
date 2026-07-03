## MODIFIED Requirements

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

A screen SHALL display full movie details with backdrop, poster, and metadata in an immersive, scroll-driven layout.

#### Scenario: Screen shows skeleton loading
- **WHEN** movie details are being fetched
- **THEN** the screen SHALL show an animated skeleton shimmer matching the final content layout

#### Scenario: Screen displays movie detail with collapsing header
- **WHEN** movie details are loaded
- **THEN** the screen SHALL display a collapsing hero header with backdrop image, gradient overlay, and poster
- **AND** scrolling SHALL collapse the header and transition the poster into the content area
- **AND** the screen SHALL display title, release date, vote average, genres, runtime, and overview

#### Scenario: Screen supports gesture dismiss
- **WHEN** the user is at scroll position 0 and drags downward
- **THEN** the screen SHALL visually shrink and slide down
- **AND** release above threshold SHALL close the screen

#### Scenario: Screen shows error with retry
- **WHEN** movie details fail to load
- **THEN** the screen SHALL show the ErrorView with retry
