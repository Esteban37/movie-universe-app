## Purpose

Presentation layer for browsing popular and top-rated TV series with infinite scroll, responsive grid layout, and premium loading/error states.

## Requirements

### Requirement: TV list screen
A `TvShowListScreen` SHALL display Popular and Top Rated TV shows in tabs.

#### Scenario: Screen shows tab bar
- **WHEN** the Series tab is active
- **THEN** a TabBar with "Popular" and "Top Rated" SHALL be visible

#### Scenario: Screen shows TV grid
- **WHEN** TV show data is loaded
- **THEN** the screen SHALL display a responsive grid of TV show cards
- **AND** column count SHALL adapt to screen width (2 / 3 / 4 columns)

#### Scenario: Screen shows loading state
- **WHEN** the initial page is loading
- **THEN** the screen SHALL show `LoadingView` or skeleton placeholders

#### Scenario: Screen shows error state
- **WHEN** the request fails
- **THEN** the screen SHALL show `ErrorView.failure` with retry
- **AND** it SHALL surface `Failure.message`, not raw exception text

#### Scenario: Screen shows empty state
- **WHEN** the API returns an empty list
- **THEN** the screen SHALL show `EmptyView`

### Requirement: Paginated TV providers
TV list tabs SHALL use paginated notifiers mirroring the movies pattern.

#### Scenario: Infinite scroll loads next page
- **WHEN** the user scrolls to the bottom of a TV list
- **AND** more pages are available
- **THEN** the provider SHALL load and append the next page

#### Scenario: Duplicate page guard
- **WHEN** a page request is already in progress
- **THEN** the provider SHALL NOT trigger additional requests

### Requirement: TV show card
List items SHALL use a TV card that maps entities to `MediaDisplayModel`.

#### Scenario: Card uses design-system media atoms
- **WHEN** a TV show card renders a poster
- **THEN** it SHALL use `PosterImage` with `TmdbImageUrl`
- **AND** it SHALL NOT use hardcoded TMDB URLs

#### Scenario: Card navigates to detail
- **WHEN** the user taps a TV show card
- **THEN** the app SHALL navigate via `AppRouter.pushTvShowDetail`

### Requirement: Provider wiring
Repository and use-case providers SHALL follow the established DI pattern.

#### Scenario: Repository provider wires DI only
- **WHEN** inspecting `tv_show_repository_provider.dart`
- **THEN** it SHALL expose `TvShowRepository` without business logic

#### Scenario: UI providers call use cases
- **WHEN** paginated TV providers fetch data
- **THEN** they SHALL read use-case providers, not the repository directly
