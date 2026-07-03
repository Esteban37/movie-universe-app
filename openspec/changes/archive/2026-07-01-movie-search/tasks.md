## 1. Domain Layer

- [x] 1.1 Create `features/search/domain/entities/search_result_entity.dart` (wrapper for MovieEntity)
- [x] 1.2 Create `features/search/domain/repositories/search_repository.dart` abstract contract
- [x] 1.3 Create `features/search/domain/usecases/search_movies.dart`

## 2. Data Layer

- [x] 2.1 Create `features/search/data/dtos/search_result_dto.dart` with Freezed + JsonSerializable
- [x] 2.2 Create `features/search/data/datasources/search_remote_datasource.dart` with Dio for /search/movie
- [x] 2.3 Create `features/search/data/repositories/search_repository_impl.dart` with DTO-to-entity mapping

## 3. Presentation Layer

- [x] 3.1 Create `features/search/presentation/providers/search_provider.dart` with debounced query handling (500ms)
- [x] 3.2 Create `features/search/presentation/screens/search_screen.dart` with TextField and results list
- [x] 3.3 Create `features/search/presentation/widgets/search_result_card.dart`

## 4. Unit Tests

- [x] 4.1 Write tests for search DTO JSON serialization
- [x] 4.2 Write tests for search data source (mock Dio)
- [x] 4.3 Write tests for search repository implementation
- [x] 4.4 Write tests for search use case
- [x] 4.5 Write tests for search provider (debounce, empty query, error states)
