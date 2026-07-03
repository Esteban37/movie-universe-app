## ADDED Requirements

### Requirement: Movie DTOs with JSON serialization
Freezed DTO classes SHALL handle TMDB API JSON deserialization.

#### Scenario: MovieDTO deserializes from JSON
- **WHEN** raw TMDB JSON is parsed
- **THEN** MovieDTO SHALL correctly deserialize all fields including poster_path, vote_average, release_date

#### Scenario: MovieDetailDTO deserializes from JSON
- **WHEN** raw TMDB movie detail JSON is parsed
- **THEN** MovieDetailDTO SHALL deserialize additional fields like backdrop_path, genres, runtime

#### Scenario: MovieResponseDTO handles paginated responses
- **WHEN** a paginated TMDB response is parsed
- **THEN** MovieResponseDTO SHALL contain page, totalPages, and List<MovieDTO> results

### Requirement: Movie remote data source
A MovieRemoteDataSource class SHALL make Dio-based API calls to TMDB.

#### Scenario: Data source calls popular movies endpoint
- **WHEN** getPopular is called
- **THEN** it SHALL make a GET request to /movie/popular with the page parameter

#### Scenario: Data source calls top rated endpoint
- **WHEN** getTopRated is called
- **THEN** it SHALL make a GET request to /movie/top_rated with the page parameter

#### Scenario: Data source calls movie details endpoint
- **WHEN** getMovieDetails is called with an ID
- **THEN** it SHALL make a GET request to /movie/{id}

### Requirement: Repository implementation with DTO-to-entity mapping
MovieRepositoryImpl SHALL implement MovieRepository and map DTOs to entities.

#### Scenario: Repository maps DTO list to entity list
- **WHEN** the data source returns MovieResponseDTO
- **THEN** the repository SHALL map each MovieDTO to MovieEntity

#### Scenario: Repository maps detail DTO to detail entity
- **WHEN** the data source returns MovieDetailDTO
- **THEN** the repository SHALL map it to MovieDetailEntity

#### Scenario: Repository propagates data source errors
- **WHEN** the data source throws an exception
- **THEN** the repository SHALL catch it and return the appropriate Failure type
