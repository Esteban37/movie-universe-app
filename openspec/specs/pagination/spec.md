## Purpose

Infinite-scroll pagination for movie lists, TV lists, and unified search results.

## Requirements

### Requirement: Infinite scroll pagination
The system SHALL load additional items as the user scrolls to the bottom of a paginated list.

#### Scenario: User scrolls to bottom of movie list
- **WHEN** the user scrolls to the bottom of the movie list
- **AND** there are more pages available
- **THEN** the system SHALL load the next page of movies
- **AND** append them to the existing list

#### Scenario: User scrolls to bottom of TV list
- **WHEN** the user scrolls to the bottom of a TV show list
- **AND** there are more pages available
- **THEN** the system SHALL load the next page of TV shows
- **AND** append them to the existing list

#### Scenario: Loading indicator at bottom during pagination
- **WHEN** the system is loading the next page
- **THEN** the system SHALL show a loading indicator at the bottom of the list

#### Scenario: No more pages to load
- **WHEN** the user scrolls to the bottom
- **AND** there are no more pages available
- **THEN** the system SHALL NOT attempt to load additional items

#### Scenario: Prevent duplicate page loads
- **WHEN** a page request is already in progress
- **THEN** the system SHALL NOT trigger additional page requests

### Requirement: Paginated search notifier
Search state SHALL be managed by a paginated notifier that supports append-on-scroll.

#### Scenario: Initial search loads page 1
- **WHEN** a debounced query is submitted
- **THEN** the notifier SHALL fetch page 1 and replace prior results

#### Scenario: Scroll loads next page
- **WHEN** the user scrolls to the bottom of search results
- **AND** `currentPage < totalPages`
- **THEN** the notifier SHALL fetch the next page and append items

#### Scenario: Loading indicator during pagination
- **WHEN** a subsequent page is loading
- **THEN** the search list SHALL show a bottom loading indicator
- **AND** existing results SHALL remain visible

#### Scenario: No more search pages
- **WHEN** the user reaches the bottom
- **AND** `currentPage >= totalPages`
- **THEN** the notifier SHALL NOT request additional pages

#### Scenario: Prevent duplicate search page loads
- **WHEN** a page request is already in progress
- **THEN** the notifier SHALL NOT trigger additional page requests

### Requirement: Query change resets pagination
Changing the search query SHALL reset pagination state.

#### Scenario: New query resets pages
- **WHEN** the debounced query changes
- **THEN** the notifier SHALL reset to page 1
- **AND** clear previously loaded results before showing new page 1 data

### Requirement: Filter does not reset pagination
Changing the type filter chip SHALL NOT re-fetch from the API.

#### Scenario: Filter applies to loaded items
- **WHEN** the user switches between All, Movies, and Series
- **THEN** the UI SHALL filter the in-memory result list
- **AND** SHALL NOT call the search endpoint solely because the filter changed

### Requirement: Pagination with active filter
When a filter is active, load-more SHALL continue fetching unfiltered pages from the API.

#### Scenario: Load more under Movies filter
- **WHEN** Movies filter is active and the user scrolls to load more
- **THEN** the notifier SHALL fetch the next API page
- **AND** the UI SHALL append only movie items from that page to the filtered view

### Requirement: Search provider uses use case
The paginated search notifier SHALL call `SearchMedia`, not the repository directly.

#### Scenario: Provider reads use case
- **WHEN** the search notifier fetches any page
- **THEN** it SHALL invoke `SearchMedia` via its use-case provider

### Requirement: Shared paginated list notifier
Movie and TV list tabs SHALL share a generic pagination base instead of duplicating notifier logic per feature.

#### Scenario: PaginatedMediaNotifier location
- **WHEN** inspecting list-tab pagination for movies or TV shows
- **THEN** concrete notifiers SHALL extend `PaginatedMediaNotifier<T>` from `lib/shared/presentation/providers/paginated_media_notifier.dart`

#### Scenario: Popular movies uses shared base
- **GIVEN** `popular_movies_provider.dart`
- **WHEN** loading the next page
- **THEN** it SHALL extend `PaginatedMediaNotifier<MovieEntity>`
- **AND** implement `fetchPage` by calling `getPopularMoviesProvider`

#### Scenario: Popular TV uses shared base
- **GIVEN** `popular_tv_shows_provider.dart`
- **WHEN** loading the next page
- **THEN** it SHALL extend `PaginatedMediaNotifier<TvShowEntity>`
- **AND** implement `fetchPage` by calling `getPopularTvShowsProvider`
