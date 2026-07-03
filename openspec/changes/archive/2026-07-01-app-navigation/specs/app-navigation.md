## ADDED Requirements

### Requirement: Fluro route definitions
The project SHALL define all application routes via Fluro.

#### Scenario: Home route registered
- **WHEN** the app starts
- **THEN** the `/` route SHALL be registered and display the home screen with tabs

#### Scenario: Movie details route registered
- **WHEN** navigating to `/movie/:id`
- **THEN** the route SHALL extract the movie ID parameter and display MovieDetailScreen

#### Scenario: Search route registered
- **WHEN** navigating to `/search`
- **THEN** the route SHALL display the SearchScreen

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
