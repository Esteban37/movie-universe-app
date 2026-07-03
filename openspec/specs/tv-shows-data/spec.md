## Purpose

Data layer for TMDB TV endpoints: DTOs, remote datasource, and repository implementation with typed error mapping.

## Requirements

### Requirement: Shared TV list DTO in core
A `TmdbTvShowDto` SHALL live in `lib/core/data/dtos/` for TMDB TV list-item payloads.

#### Scenario: TmdbTvShowDto deserializes list items
- **WHEN** TMDB TV list JSON is parsed
- **THEN** `TmdbTvShowDto` SHALL deserialize id, name, poster_path, vote_average, first_air_date, and overview

### Requirement: TV detail DTO
A feature-local `TvShowDetailDto` SHALL deserialize `/tv/{id}` responses.

#### Scenario: Detail DTO includes TV-specific fields
- **WHEN** TMDB TV detail JSON is parsed
- **THEN** the DTO SHALL include backdrop_path, genres, tagline, number_of_seasons, number_of_episodes, status, and networks

### Requirement: TV remote data source
A `TvShowRemoteDataSource` SHALL call TMDB TV endpoints via Dio.

#### Scenario: Data source calls popular endpoint
- **WHEN** getPopular is called with a page
- **THEN** it SHALL GET `/tv/popular` with the page parameter

#### Scenario: Data source calls top rated endpoint
- **WHEN** getTopRated is called with a page
- **THEN** it SHALL GET `/tv/top_rated` with the page parameter

#### Scenario: Data source calls detail endpoint
- **WHEN** getTvShowDetails is called with an ID
- **THEN** it SHALL GET `/tv/{id}`

#### Scenario: Data source maps Dio errors to Failure
- **WHEN** a network or HTTP error occurs
- **THEN** the repository layer SHALL throw a typed `Failure` subtype

### Requirement: TV repository implementation
`TvShowRepositoryImpl` SHALL implement `TvShowRepository` with DTO-to-entity mapping.

#### Scenario: Repository maps list results
- **WHEN** the data source returns TV list DTOs
- **THEN** the repository SHALL map each to `TvShowEntity` via core mappers

#### Scenario: Repository maps detail result
- **WHEN** the data source returns a detail DTO
- **THEN** the repository SHALL map it to `TvShowDetailEntity`

### Requirement: Cross-feature data decoupling
TV data layer SHALL NOT import movies data layer.

#### Scenario: TV data imports
- **WHEN** scanning `lib/features/tv_shows/data/`
- **THEN** no imports reference `features/movies/data`
