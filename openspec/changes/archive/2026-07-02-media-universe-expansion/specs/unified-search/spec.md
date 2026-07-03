## Purpose

Replace movie-only search with unified multi-media search returning `MediaItem` results, decoupling search from the movies feature domain.

## ADDED Requirements

### Requirement: Unified search repository contract
`SearchRepository` SHALL expose search that returns paginated `MediaItem` results.

#### Scenario: Repository defines searchMedia
- **WHEN** searchMedia is called with a query string and page
- **THEN** it SHALL return a paginated list of `MediaItem` including movies and TV shows

### Requirement: SearchMedia use case
A `SearchMedia` use case SHALL invoke the search repository.

#### Scenario: Use case calls repository with query and page
- **WHEN** `SearchMedia` is executed with a query and page
- **THEN** it SHALL call `repository.searchMedia` with both parameters

### Requirement: Multi search data source
`SearchRemoteDataSource` SHALL call TMDB `/search/multi`.

#### Scenario: Data source calls multi search endpoint
- **WHEN** search is called with a query and page
- **THEN** it SHALL GET `/search/multi` with query and page parameters

#### Scenario: Non-media results filtered
- **WHEN** TMDB returns entries with media_type other than movie or tv
- **THEN** the data layer SHALL exclude them from mapped results

### Requirement: Search result entity uses MediaItem
`SearchResultEntity` SHALL wrap `List<MediaItem>` instead of `List<MovieEntity>`.

#### Scenario: Entity holds mixed results
- **WHEN** multi search returns movies and TV shows
- **THEN** `SearchResultEntity.results` SHALL contain `MediaItem` variants for each

#### Scenario: Search domain decoupled from movies
- **WHEN** scanning `lib/features/search/domain/`
- **THEN** no files SHALL import `features/movies/domain/entities/movie_entity.dart`
- **AND** they MAY import `core/domain/entities/media_item.dart`

### Requirement: Search screen with type filters
The search screen SHALL support filtering results by media type without additional API calls.

#### Scenario: Filter chips visible
- **WHEN** the search screen is displayed
- **THEN** filter chips for All, Movies, and Series SHALL be visible

#### Scenario: Client-side filter on All
- **WHEN** All is selected
- **THEN** the screen SHALL show all loaded `MediaItem` results

#### Scenario: Client-side filter on Movies
- **WHEN** Movies is selected
- **THEN** the screen SHALL show only `MediaItem.movie` variants from loaded results

#### Scenario: Client-side filter on Series
- **WHEN** Series is selected
- **THEN** the screen SHALL show only `MediaItem.tvShow` variants from loaded results

### Requirement: Search result navigation
Tapping a search result SHALL route to the correct detail screen.

#### Scenario: Movie result navigation
- **WHEN** the user taps a movie result
- **THEN** the app SHALL navigate via `AppRouter.pushMovieDetail`

#### Scenario: TV result navigation
- **WHEN** the user taps a TV show result
- **THEN** the app SHALL navigate via `AppRouter.pushTvShowDetail`

### Requirement: Search debounce preserved
Search input SHALL retain 500 ms debounce behavior.

#### Scenario: Provider debounces input
- **WHEN** the user types a search query
- **THEN** the provider SHALL wait 500 ms after the last keystroke before fetching page 1

#### Scenario: Provider clears on empty query
- **WHEN** the search query is empty
- **THEN** the provider SHALL clear results and NOT make an API request

### Requirement: Search error and empty states
Search SHALL surface user-safe failure messages and empty states.

#### Scenario: Empty results message
- **WHEN** the query returns no media results
- **THEN** the screen SHALL display an empty state with context

#### Scenario: Error state
- **WHEN** the search request fails
- **THEN** the screen SHALL show `ErrorView.failure` with `Failure.message`
