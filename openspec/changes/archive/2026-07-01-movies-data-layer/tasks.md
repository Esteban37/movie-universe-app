## 1. Domain Layer — Entities

- [x] 1.1 Create `features/movies/domain/entities/movie_entity.dart` with Freezed (id, title, posterPath, voteAverage, releaseDate, overview)
- [x] 1.2 Create `features/movies/domain/entities/movie_detail_entity.dart` with Freezed (extends MovieEntity: backdropPath, genres, runtime, tagline)

## 2. Domain Layer — Repository Contract

- [x] 2.1 Create `features/movies/domain/repositories/movie_repository.dart` abstract class with getPopular, getTopRated, getMovieDetails methods

## 3. Domain Layer — Use Cases

- [x] 3.1 Create `features/movies/domain/usecases/get_popular_movies.dart`
- [x] 3.2 Create `features/movies/domain/usecases/get_top_rated_movies.dart`
- [x] 3.3 Create `features/movies/domain/usecases/get_movie_details.dart`

## 4. Data Layer — DTOs

- [x] 4.1 Create `features/movies/data/dtos/movie_dto.dart` with Freezed + JsonSerializable
- [x] 4.2 Create `features/movies/data/dtos/movie_detail_dto.dart` with Freezed + JsonSerializable
- [x] 4.3 Create `features/movies/data/dtos/movie_response_dto.dart` with Freezed (page, totalPages, results)

## 5. Data Layer — Data Source

- [x] 5.1 Create `features/movies/data/datasources/movie_remote_datasource.dart` with Dio for /movie/popular, /movie/top_rated, /movie/{id}

## 6. Data Layer — Repository Implementation

- [x] 6.1 Create `features/movies/data/repositories/movie_repository_impl.dart` with DTO-to-entity mapping

## 7. Unit Tests

- [x] 7.1 Write tests for MovieEntity and MovieDetailEntity creation
- [x] 7.2 Write tests for MovieDTO JSON serialization (fromJson, toJson)
- [x] 7.3 Write tests for MovieDetailDTO JSON serialization
- [x] 7.4 Write tests for MovieResponseDTO pagination parsing
- [x] 7.5 Write tests for MovieRemoteDataSource (mock Dio)
- [x] 7.6 Write tests for MovieRepositoryImpl (DTO-to-entity mapping)
- [x] 7.7 Write tests for all three use cases
