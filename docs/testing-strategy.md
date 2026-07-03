# Testing Strategy

## Framework

- **`flutter_test`** — standard Flutter/Dart test runner and matchers
- **`integration_test`** — end-to-end shell navigation flows (offline mocks)
- **`mocktail`** — lightweight mocking without code generation
- **`flutter_riverpod`** / **`riverpod`** — `ProviderContainer` with overrides for provider unit tests

## Test Structure

Tests mirror the `lib/` directory structure under `test/`:

```
test/
  architecture/          # layer boundary rules
  core/
  features/
    movies/
    search/
    tv_shows/
  shared/
    domain/
    design_system/
  helpers/
    provider_container.dart
    offline_app_overrides.dart
    test_fixtures.dart
  widget_test.dart

integration_test/
  helpers/
    navigation_harness.dart   # offline AppShell + repository mocks
  navigation_flows_test.dart  # Movies / Series / Search → detail
```

## Conventions

### Naming
- Test files match the source file name with `_test.dart` suffix, placed in the same relative path under `test/` as the source under `lib/`.

### Test Structure
- Use `group()` to organize related tests by class or feature.
- Use `setUp()` for shared mock initialization.
- Each test validates a single behavior.

### Provider Tests
- Define mock classes extending `Mock` from `mocktail`.
- Use `createTestContainer` from `test/helpers/provider_container.dart`.
- Override `movieRepositoryProvider`, `tvShowRepositoryProvider`, or `searchRepositoryProvider` — never instantiate repositories in widget tests.

### Integration Tests
- Use `integration_test/helpers/navigation_harness.dart` for offline `AppShell` setup.
- Run with `flutter test integration_test`.

### Fixtures
- Use `TestFixtures` from `test/helpers/test_fixtures.dart` for reusable sample data.

## Code generation (local and CI)

Freezed / `json_serializable` outputs (`*.freezed.dart`, `*.g.dart`) are **gitignored** — they are not in the repo.

After every fresh clone **and** in CI, run code generation before analyze or tests:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Without this step, `dart analyze` fails (missing generated parts) and tests will not compile.

## Scope

### Test counts (latest `main`)

| Suite | Command | Count |
|-------|---------|------:|
| Unit + widget (incl. 8 architecture rules) | `flutter test` | 210 |
| Integration (shell navigation) | `flutter test integration_test` | 3 |
| **Total** | both | **213** |

Architecture-only subset: `flutter test test/architecture/` → 8 tests.

### In Scope
- Unit tests for DTOs, entities, use cases, data sources, repositories, and providers.
- Widget tests for design-system components, list/detail navigation, and immersive detail behavior.
- Architecture boundary tests in `test/architecture/layer_boundaries_test.dart`.
- Integration tests for shell tab navigation flows.
- CI: `flutter pub get`, **`build_runner`**, `dart analyze --fatal-warnings`, `dependency_validator`, full test suites.

### Deferred (Future)
- Golden tests
- Firebase Test Lab / device farm runs
- Live TMDB integration tests (network)

## CI

GitHub Actions workflow `.github/workflows/ci.yml` runs on push/PR to `main` and `master`:

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs` — **required** (generated Freezed/json files are gitignored)
3. `dart analyze --fatal-warnings`
4. `dart run dependency_validator`
5. `flutter test`
6. `flutter test integration_test`

See [Code generation (local and CI)](#code-generation-local-and-ci) above for why step 2 is mandatory.

See also [openspec.md](openspec.md) for OpenSpec in CI.
