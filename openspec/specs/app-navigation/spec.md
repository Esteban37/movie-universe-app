## Purpose

Application routing and shell navigation: Fluro routes, bottom navigation shell, and deep links for movies, TV series, and search.

## Requirements

### Requirement: Bottom navigation shell
The app SHALL provide a bottom navigation shell with Movies, Series, and Search destinations.

#### Scenario: Shell displays three tabs
- **WHEN** the app home is shown
- **THEN** a BottomNavigationBar with Movies, Series, and Search SHALL be visible

#### Scenario: Movies tab shows movie list
- **WHEN** the Movies tab is selected
- **THEN** `MovieListScreen` SHALL be displayed with Popular and Top Rated sub-tabs

#### Scenario: Series tab shows TV list
- **WHEN** the Series tab is selected
- **THEN** `TvShowListScreen` SHALL be displayed with Popular and Top Rated sub-tabs

#### Scenario: Search tab shows search screen
- **WHEN** the Search tab is selected
- **THEN** `SearchScreen` SHALL be displayed

#### Scenario: Theme toggle remains accessible
- **WHEN** any shell tab is active
- **THEN** the user SHALL be able to toggle dark/light theme via the existing theme control

### Requirement: Fluro route definitions
The project SHALL define all application routes via Fluro, including TV detail.

#### Scenario: Home route registered
- **WHEN** the app starts
- **THEN** the `/` route SHALL be registered and display the app shell with bottom navigation

#### Scenario: Movie details route registered
- **WHEN** navigating to `/movie/:id`
- **THEN** the route SHALL extract the movie ID parameter and display `MovieDetailScreen`

#### Scenario: TV details route registered
- **WHEN** navigating to `/tv/:id`
- **THEN** the route SHALL extract the TV show ID parameter and display `TvShowDetailScreen`

#### Scenario: Search route registered
- **WHEN** navigating to `/search`
- **THEN** the route SHALL display the unified `SearchScreen`

### Requirement: TV show detail route
Fluro SHALL register a TV detail route with the same transition semantics as movies.

#### Scenario: pushTvShowDetail uses non-opaque fade
- **WHEN** `AppRouter.pushTvShowDetail` is called
- **THEN** navigation SHALL use `opaque: false` and a fade transition
- **AND** match the immersive dismiss behavior of `pushMovieDetail`

### Requirement: Home route uses shell
The `/` route SHALL render the bottom navigation shell instead of only `MovieListScreen`.

#### Scenario: Root route shows shell
- **WHEN** the app starts at `/`
- **THEN** the bottom navigation shell SHALL be the root presentation widget

### Requirement: Search route compatibility
The `/search` route MAY remain registered for deep linking but SHALL render the same search experience as the Search tab.

#### Scenario: Direct search navigation
- **WHEN** navigating to `/search`
- **THEN** the unified search screen SHALL be displayed

### Requirement: MaterialApp with Fluro router
The app SHALL use MaterialApp with Fluro as the routing solution.

#### Scenario: MaterialApp configured with router
- **WHEN** the app initializes
- **THEN** MaterialApp SHALL use Fluro's router for navigation

### Requirement: Dio provider injection
The app SHALL provide the Dio instance via Riverpod for dependency injection.

#### Scenario: Dio provider registered
- **WHEN** the app initializes
- **THEN** a Dio provider SHALL be available for injection into all data sources
