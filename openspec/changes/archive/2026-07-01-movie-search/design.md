## Context

Movie search is a self-contained feature with its own domain, data, and presentation layers. It interacts with the TMDB search endpoint and requires debounced input handling.

## Goals / Non-Goals

**Goals:**
- SearchEntity, SearchRepository contract, SearchMovies use case
- SearchResultDTO, SearchRemoteDataSource, SearchRepositoryImpl
- SearchProvider with 500ms debounce
- SearchScreen with search input field and results list
- SearchResultCard widget

**Non-Goals:**
- No integration with popular/top-rated tabs
- No search history

## Decisions

### 1. Separate Feature Module
- **Choice**: `lib/features/search/` with its own data/domain/presentation layers
- **Rationale**: Clean Architecture separation. Search has different entity shape and API endpoint.

### 2. Debounce Implementation
- **Choice**: Simple `Debouncer` utility class in core/utils
- **Rationale**: Reusable. Cancels previous timer on each new input, fires after 500ms of inactivity.

### 3. Search State
- **Choice**: `AsyncValue<List<MovieEntity>>` for results, separate string for query
- **Rationale**: Query drives the search, results show the API response. Clear separation.

## Risks / Trade-offs

- [Risk] Rapid typing causes many API calls → Mitigation: debounce prevents requests until user pauses
