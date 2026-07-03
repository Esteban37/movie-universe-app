## Why

All movie-related features (popular, top-rated, details) share the same domain entities, repository contract, DTOs, and data source logic. This change implements the shared data and domain layer for the movies feature before any UI screens are built.

## What Changes

- Create `features/movies/domain/entities/` with Freezed models (MovieEntity, MovieDetailEntity)
- Create `features/movies/domain/repositories/` with MovieRepository contract
- Create `features/movies/domain/usecases/` (getPopular, getTopRated, getMovieDetails)
- Create `features/movies/data/dtos/` with Freezed + JsonSerializable (MovieDTO, MovieDetailDTO, MovieResponseDTO)
- Create `features/movies/data/datasources/` with MovieRemoteDataSource (Dio-based)
- Create `features/movies/data/repositories/` with MovieRepositoryImpl (DTO-to-entity mapping)
- Write unit tests for all domain and data layer components

## Capabilities

### New Capabilities
- `movies-domain`: Domain entities, repository contracts, and use cases for movie operations
- `movies-data`: DTOs with JSON serialization, remote data source, and repository implementation with mapping

### Modified Capabilities
None.

## Impact

- New module under `lib/features/movies/` (data + domain layers)
- Unit tests for entities, DTOs, data source, repository, and use cases
- Prerequisite for movies-ui and movie-details changes
