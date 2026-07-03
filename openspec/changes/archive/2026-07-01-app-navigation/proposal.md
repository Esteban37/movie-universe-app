## Why

The application needs centralized navigation wiring to connect all screens: home tab bar (popular + top-rated), movie details screen, and search screen. This change implements Fluro routing and finalizes `main.dart` with ProviderScope and MaterialApp configuration.

## What Changes

- Create `core/router/` with Fluro route definitions and handlers
- Register routes: home (tab bar), movie details (movie ID parameter), search
- Configure `MaterialApp` with Fluro router and theme
- Wire up `main.dart` with ProviderScope, Dio injection, and router setup
- Write unit tests for route generation and navigation

## Capabilities

### New Capabilities
- `app-navigation`: Centralized Fluro-based routing with typed route parameters

### Modified Capabilities
None.

## Impact

- New `core/router/` module
- Updated `lib/main.dart` as the app entry point
- Requires all screen changes (movies-ui, movie-search) to be implemented first
- Final integration change before testing
