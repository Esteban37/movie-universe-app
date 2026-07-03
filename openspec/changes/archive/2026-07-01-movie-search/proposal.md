## Why

Searching movies by name is a core feature of the application. It requires its own data flow (search endpoint, query parameter handling), debounced input logic, and dedicated UI — making it a self-contained feature change.

## What Changes

- Create `features/search/domain/` (SearchEntity, SearchRepository contract, SearchMovies use case)
- Create `features/search/data/` (SearchResultDTO, SearchRemoteDataSource, SearchRepositoryImpl)
- Create `features/search/presentation/` (SearchProvider with debounce, SearchScreen, SearchResultCard)
- Implement 500ms debounce on search input
- Write unit tests for all layers

## Capabilities

### New Capabilities
- `movie-search`: Full search feature with debounced input, API integration, result display, and empty/error states

### Modified Capabilities
None.

## Impact

- New module under `lib/features/search/` covering all Clean Architecture layers
- Unit tests for domain, data, and presentation layers
- Requires core-networking for Dio client
