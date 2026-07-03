## 1. Router

- [x] 1.1 Create `core/router/app_router.dart` with Fluro Router instance and route definitions
- [x] 1.2 Register home route `/` → MovieListScreen with tabs
- [x] 1.3 Register movie details route `/movie/:id` → MovieDetailScreen with ID parameter extraction
- [x] 1.4 Register search route `/search` → SearchScreen

## 2. App Entry Point

- [x] 2.1 Update `lib/main.dart` with ProviderScope wrapping the app
- [x] 2.2 Configure MaterialApp with Fluro router and AppTheme
- [x] 2.3 Inject Dio provider at the app root level

## 3. Unit Tests

- [x] 3.1 Write tests for route generation
- [x] 3.2 Write tests for route parameter extraction (movie ID)
