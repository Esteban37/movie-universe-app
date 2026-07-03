## ADDED Requirements

### Requirement: Search repository contract
An abstract SearchRepository SHALL define the search data access contract.

#### Scenario: Repository defines searchMovies
- **WHEN** searchMovies is called with a query string and page
- **THEN** it SHALL return a paginated list of search results

### Requirement: Search use case
A SearchMovies use case SHALL invoke the search repository.

#### Scenario: Use case calls repository with query
- **WHEN** SearchMovies is executed with a query
- **THEN** it SHALL call repository.searchMovies with the query and page

### Requirement: Search data source
A SearchRemoteDataSource SHALL call the TMDB search endpoint.

#### Scenario: Data source calls search endpoint
- **WHEN** search is called with a query
- **THEN** it SHALL make a GET request to /search/movie with query and page parameters

### Requirement: Search DTO
A SearchResultDTO SHALL deserialize TMDB search results.

#### Scenario: DTO deserializes search results
- **WHEN** TMDB search JSON is parsed
- **THEN** SearchResultDTO SHALL correctly deserialize the response

### Requirement: Search repository implementation
SearchRepositoryImpl SHALL implement the search contract with DTO-to-entity mapping.

#### Scenario: Repository maps search results
- **WHEN** the data source returns search results
- **THEN** the repository SHALL map each SearchResultDTO to MovieEntity

### Requirement: Search provider with debounce
A provider SHALL manage search state with debounced input.

#### Scenario: Provider debounces input
- **WHEN** the user types a search query
- **THEN** the provider SHALL wait 500ms after the last keystroke before making the API call

#### Scenario: Provider clears results on empty query
- **WHEN** the search query is empty
- **THEN** the provider SHALL clear results and NOT make an API request

### Requirement: Search screen
A screen SHALL provide search input and display results.

#### Scenario: Screen shows search field
- **WHEN** the search screen is displayed
- **THEN** a TextField SHALL be visible for entering search queries

#### Scenario: Screen shows loading during search
- **WHEN** search results are being fetched
- **THEN** the screen SHALL show the LoadingView

#### Scenario: Screen shows search results
- **WHEN** search results are returned
- **THEN** the screen SHALL display a list of SearchResultCard widgets

#### Scenario: Screen shows empty results
- **WHEN** the search query returns no results
- **THEN** the screen SHALL display "No results found" message

#### Scenario: Screen shows error state
- **WHEN** the search request fails
- **THEN** the screen SHALL show the ErrorView with retry
