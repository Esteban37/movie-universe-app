## Context

Movies feature data layer: TMDB API integration for movie endpoints. Domain layer: entities, repository contracts, and use cases consumed by the presentation layer.

## Goals / Non-Goals

**Goals:**
- Freezed entities: MovieEntity (id, title, posterPath, rating, releaseDate, overview), MovieDetailEntity (adds backdropPath, genres, runtime, tagline)
- Repository contract: getPopular(page), getTopRated(page), getMovieDetails(id)
- Use cases: GetPopularMovies, GetTopRatedMovies, GetMovieDetails
- DTOs with JsonSerializable: MovieDTO, MovieDetailDTO, MovieResponseDTO (paginated wrapper)
- Remote data source with Dio for TMDB movie endpoints
- Repository implementation mapping DTOs to entities
- Unit tests for all components

**Non-Goals:**
- No presentation layer
- No search-specific data flow (separate change)

## Decisions

### 1. DTO to Entity Mapping
- **Choice**: Mapping at repository boundary, not in data source
- **Rationale**: Repository is the contract boundary. Data source returns DTOs, repository maps to entities. Domain layer never depends on data types.

### 2. Pagination Model
- **Choice**: MovieResponseDTO wrapping page, totalPages, results list
- **Rationale**: TMDB API returns paginated responses. The DTO captures the full response. Provider layer manages page state and accumulation.

### 3. Use Case Pattern
- **Choice**: Each use case is a single-method class (call or execute)
- **Rationale**: Follows Clean Architecture recommendation. Easy to test, easy to add cross-cutting concerns (logging, caching) later.

## Risks / Trade-offs

- [Risk] TMDB API changes response format → Mitigation: DTOs isolate API shape from domain
