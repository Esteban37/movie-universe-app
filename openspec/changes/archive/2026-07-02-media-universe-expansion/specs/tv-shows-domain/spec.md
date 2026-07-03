## Purpose

Domain entities, repository contract, and use cases for TV show operations. Consumed by the presentation layer; never depends on data or presentation types.

## ADDED Requirements

### Requirement: TvShow entity
A Freezed `TvShowEntity` SHALL represent a TV series in the domain layer.

#### Scenario: TvShowEntity has required fields
- **WHEN** a `TvShowEntity` is instantiated
- **THEN** it SHALL have id, name, posterPath, voteAverage, firstAirDate, and overview fields

#### Scenario: TvShowEntity is immutable
- **WHEN** a `TvShowEntity` is created
- **THEN** it SHALL be immutable
- **AND** support copyWith for modified copies

### Requirement: TvShow detail entity
A Freezed `TvShowDetailEntity` SHALL extend list-item TV data with detail fields.

#### Scenario: TvShowDetailEntity has additional fields
- **WHEN** a `TvShowDetailEntity` is instantiated
- **THEN** it SHALL include all list fields plus backdropPath, genres, tagline, numberOfSeasons, numberOfEpisodes, status, and networks

### Requirement: TvShow repository contract
An abstract `TvShowRepository` SHALL define TV data access.

#### Scenario: Repository defines getPopular
- **WHEN** getPopular is called with a page number
- **THEN** it SHALL return a paginated list of `TvShowEntity`

#### Scenario: Repository defines getTopRated
- **WHEN** getTopRated is called with a page number
- **THEN** it SHALL return a paginated list of `TvShowEntity`

#### Scenario: Repository defines getTvShowDetails
- **WHEN** getTvShowDetails is called with a TV show ID
- **THEN** it SHALL return a `TvShowDetailEntity`

### Requirement: TvShow use cases
Use case classes SHALL encapsulate repository operations; presentation SHALL access TV data exclusively through use cases.

#### Scenario: GetPopularTvShows calls repository
- **WHEN** `GetPopularTvShows` is executed
- **THEN** it SHALL call `repository.getPopular` with the provided page

#### Scenario: GetTopRatedTvShows calls repository
- **WHEN** `GetTopRatedTvShows` is executed
- **THEN** it SHALL call `repository.getTopRated` with the provided page

#### Scenario: GetTvShowDetails calls repository
- **WHEN** `GetTvShowDetails` is executed with a TV show ID
- **THEN** it SHALL call `repository.getTvShowDetails` with that ID

#### Scenario: Popular TV provider consumes the use case
- **WHEN** the popular TV shows provider fetches a page
- **THEN** it SHALL invoke `GetPopularTvShows`
- **AND** it SHALL NOT call the repository directly

#### Scenario: TV details provider consumes the use case
- **WHEN** the TV show details provider loads a show
- **THEN** it SHALL invoke `GetTvShowDetails`
- **AND** it SHALL NOT call the repository directly
