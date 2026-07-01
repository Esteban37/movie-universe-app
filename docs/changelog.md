# Changelog

## testing-setup

- Created `test/helpers/test_fixtures.dart` with sample DTO/entity factory methods and JSON fixtures.
- Created `test/helpers/mock_providers.dart` with `MockMovieRepository`, `MockSearchMovies`, and `ProviderContainer` helper functions.
- Ran `dart analyze` and fixed 25 issues (unused imports, `sort_constructors_first`, `prefer_const_constructors`).
- Ran `dart format .` on all files (41 files formatted).
- Ran full test suite — all 79 tests pass.
- Added `test/features/search/domain/entities/search_result_entity_test.dart` for previously untested `SearchResultEntity`.
- Created `docs/Testing_Strategy.md` documenting test structure and conventions.
