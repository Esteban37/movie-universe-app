## Why

The project needs standardized testing infrastructure — shared mock factories, provider override utilities, test fixtures, and proper test configuration — to ensure consistent and maintainable tests across all features. This change wraps up the testing strategy and fills any coverage gaps.

## What Changes

- Create shared test helpers and mock factories in `test/helpers/`
- Create test fixtures (sample movie DTOs, responses)
- Create test-specific provider overrides for Riverpod
- Configure `dart analyze` and ensure zero warnings
- Run full test suite and fix any failures
- Update `docs/Testing_Strategy.md` with final approach

## Capabilities

### New Capabilities
- `testing-infrastructure`: Shared test utilities, mock factories, fixtures, and configuration

### Modified Capabilities
None.

## Impact

- New `test/helpers/` directory
- Updated test documentation
- Requires all other changes to be implemented first
- Final quality gate before project completion
