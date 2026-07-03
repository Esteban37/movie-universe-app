## Why

Every feature in Movie Universe depends on core infrastructure: HTTP networking to TMDB, centralized error handling, shared UI components, theming, and utility classes. This change implements these cross-cutting concerns before any feature-specific code is written.

## What Changes

- Create `core/network/` with Dio client, interceptors (auth, logging, retry), API constants
- Create `core/errors/` with typed failures, error handler, exception mapping
- Create `core/theme/` with Material 3 theme configuration
- Create `shared/widgets/` with loading, error, empty state components
- Create `core/utils/` with debouncer, extensions, formatters
- Write unit tests for networking and error handling

## Capabilities

### New Capabilities
- `core-networking`: Centralized Dio HTTP client with auth, logging, retry interceptors
- `core-error-handling`: Typed failure hierarchy and exception-to-failure mapping
- `shared-widgets`: Reusable loading, error, and empty state widgets
- `app-theme`: Material 3 theme with light mode support

### Modified Capabilities
None.

## Impact

- New modules under `lib/core/` and `lib/shared/`
- Unit tests for networking (interceptors, client config) and error handling
- All future features consume these shared components
