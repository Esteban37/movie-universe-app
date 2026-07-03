## Context

Standardized testing infrastructure to ensure consistent, maintainable tests across all features. This is the final quality gate after all features are implemented.

## Goals / Non-Goals

**Goals:**
- Shared test helpers: mock factories for DTOs/entities, fake data source
- Riverpod provider override utilities for test containers
- Sample fixtures (movie DTO JSON, response objects)
- `dart analyze` passes with zero warnings
- Full test suite passes with no failures

**Non-Goals:**
- No widget or integration tests (deferred)
- No golden tests (deferred)

## Decisions

### 1. Mock Strategy
- **Choice**: Mocktail for mocking — lighter than Mockito, no code generation
- **Rationale**: Already specified in README. Simple API, no build_runner dependency for tests.

### 2. Test Fixtures
- **Choice**: Static factory methods on DTOs returning sample instances
- **Rationale**: Reusable across all test files, type-safe, easy to customize per test.

### 3. Provider Overrides
- **Choice**: `ProviderContainer` with overridden providers instead of pumpWidget
- **Rationale**: Tests business logic without widget tree overhead.

## Risks / Trade-offs

- [Risk] Mocktail has fewer features than Mockito → Acceptable for current scope
