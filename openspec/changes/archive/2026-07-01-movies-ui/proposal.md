## Why

The core movie browsing experience — popular movies, top-rated movies, and movie details — needs presentation layer implementation with Riverpod state management and responsive Flutter UI. This change completes the full user-facing movie features.

## What Changes

- Create `features/movies/presentation/providers/` (popular movies, top-rated movies, movie details)
- Create `features/movies/presentation/screens/` (MovieListScreen with tabs, MovieDetailScreen)
- Create `features/movies/presentation/widgets/` (MovieCard, MovieGrid, detail widgets)
- Implement infinite scroll pagination in movie list providers
- Implement loading, error, and empty states for all screens
- Implement responsive layout (single column phone, multi-column tablet)
- Write unit tests for all providers

## Capabilities

### New Capabilities
- `popular-movies-ui`: Screen with paginated popular movies grid, loading/error/empty states
- `top-rated-movies-ui`: Screen with paginated top-rated movies grid, loading/error/empty states
- `movie-details-ui`: Detail screen with backdrop, poster, title, rating, overview, genres

### Modified Capabilities
None.

## Impact

- New presentation layer under `lib/features/movies/presentation/`
- Unit tests for all movie providers
- Requires movies-data-layer to be implemented first
- Screens will be wired to navigation in the app-navigation change
