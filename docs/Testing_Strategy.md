# Testing Strategy

## Framework

- **`flutter_test`** — standard Flutter/Dart test runner and matchers
- **`mocktail`** — lightweight mocking without code generation
- **`flutter_riverpod`** — `ProviderContainer` with overrides for provider unit tests

## Test Structure

Tests mirror the `lib/` directory structure under `test/`:

```
test/
  core/
    errors/
    network/
    router/
  features/
    movies/
      data/
        datasources/
        dtos/
        repositories/
      domain/
        entities/
        usecases/
      presentation/
        providers/
    search/
      data/
        datasources/
        dtos/
        repositories/
      domain/
        entities/
        usecases/
      presentation/
        providers/
  helpers/
    test_fixtures.dart
    mock_providers.dart
  widget_test.dart
```

## Conventions

### Naming
- Test files match the source file name with `_test.dart` suffix, placed in the same relative path under `test/` as the source under `lib/`.

### Test Structure
- Use `group()` to organize related tests by class or feature.
- Use `setUp()` for shared mock initialization.
- Each test validates a single behavior.

### DTO Tests
- Test `fromJson` deserialization and `toJson` serialization with sample JSON maps.
- Test null field handling where applicable.

### Entity Tests
- Test creation with required fields.
- Test `copyWith` behavior.
- Test equality via `==` (freezed-generated `props`).

### Use Case Tests
- Mock the repository dependency.
- Verify the use case calls the correct repository method with the expected parameters.
- Test default parameter values.

### Provider Tests
- Define mock classes extending `Mock` from `mocktail`.
- Create a `ProviderContainer` with overridden dependencies.
- For `AsyncNotifierProvider`, call `.future` to wait for initial data.
- Test loading, error, and edge case states.

### Fixtures
- Use `TestFixtures` factory methods and JSON constants from `test/helpers/test_fixtures.dart` for reusable sample data.
- Use `createMovieRepositoryContainer` and `createSearchMoviesContainer` from `test/helpers/mock_providers.dart` for provider test setups.

## Scope

### In Scope
- Unit tests for DTOs, entities, use cases, data sources, repositories, and providers.
- Static analysis with `dart analyze` (zero warnings policy).

### Deferred (Future)
- Widget tests
- Integration tests
- Golden tests
