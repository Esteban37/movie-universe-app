## ADDED Requirements

### Requirement: Movie entity
A Freezed MovieEntity SHALL represent a movie in the domain layer.

#### Scenario: MovieEntity has required fields
- **WHEN** a MovieEntity is instantiated
- **THEN** it SHALL have id, title, posterPath, voteAverage, releaseDate, and overview fields

#### Scenario: MovieEntity is immutable
- **WHEN** a MovieEntity is created
- **THEN** it SHALL be immutable (all fields final)
- **AND** support copyWith for creating modified copies

### Requirement: Movie detail entity
A Freezed MovieDetailEntity SHALL extend MovieEntity with additional details.

#### Scenario: MovieDetailEntity has additional fields
- **WHEN** a MovieDetailEntity is instantiated
- **THEN** it SHALL include all MovieEntity fields plus backdropPath, genres, runtime, and tagline

### Requirement: Movie repository contract
An abstract MovieRepository class SHALL define the contract for movie data access.

#### Scenario: Repository defines getPopular
- **WHEN** getPopular is called with a page number
- **THEN** it SHALL return a paginated list of MovieEntity

#### Scenario: Repository defines getTopRated
- **WHEN** getTopRated is called with a page number
- **THEN** it SHALL return a paginated list of MovieEntity

#### Scenario: Repository defines getMovieDetails
- **WHEN** getMovieDetails is called with a movie ID
- **THEN** it SHALL return a MovieDetailEntity

### Requirement: Movie use cases
Use case classes SHALL encapsulate movie repository operations.

#### Scenario: GetPopularMovies calls repository
- **WHEN** GetPopularMovies is executed
- **THEN** it SHALL call repository.getPopular with the provided page

#### Scenario: GetTopRatedMovies calls repository
- **WHEN** GetTopRatedMovies is executed
- **THEN** it SHALL call repository.getTopRated with the provided page

#### Scenario: GetMovieDetails calls repository
- **WHEN** GetMovieDetails is executed with a movie ID
- **THEN** it SHALL call repository.getMovieDetails with that ID
