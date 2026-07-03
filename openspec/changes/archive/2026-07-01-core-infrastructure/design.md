## Context

Cross-cutting infrastructure needed by all features: HTTP networking, error handling, shared UI components, and theming. These are implemented once and consumed by all feature modules.

## Goals / Non-Goals

**Goals:**
- Dio-based HTTP client with auth, logging, retry interceptors
- Typed failure hierarchy (Network, Server, Timeout, Unexpected)
- Shared widgets: LoadingView, ErrorView, EmptyView
- Material 3 light theme
- Utility classes: Debouncer, extensions

**Non-Goals:**
- No dark theme (deferred)
- No offline caching (deferred)
- No feature-specific code

## Decisions

### 1. Interceptor Architecture
- **Choice**: Separate interceptors for auth, logging, retry — composable via Dio's interceptor pipeline
- **Rationale**: Single responsibility, testable in isolation, easy to add/remove.
- **Flow**: AuthInterceptor → LoggingInterceptor → RetryInterceptor → HTTP request

### 2. Failure Types
- **Choice**: Sealed class hierarchy with `Failure` base, typed subtypes
- **Rationale**: Pattern matching in Riverpod providers, precise error handling per type.

### 3. Shared Widgets
- **Choice**: Three stateless widgets: `LoadingView`, `ErrorView` (with retry callback), `EmptyView` (with message)
- **Rationale**: Consistent UI across all screens, single point of change for error/loading UX.

## Risks / Trade-offs

- [Risk] Retry interceptor could cause infinite retries → Mitigation: max 3 retries with exponential backoff, only on GET requests
