## Context

Final integration of all screens into a navigable application using Fluro for centralized route management.

## Goals / Non-Goals

**Goals:**
- Fluro router with route definitions for home, movie details, search
- Route handlers with typed parameters (movie ID for details)
- `lib/main.dart` with ProviderScope, Dio injection, MaterialApp.router
- Transition animations between screens

**Non-Goals:**
- No deep linking
- No web URL support

## Decisions

### 1. Fluro Route Definition
- **Choice**: Static `AppRouter` class with `defineRoutes()` and `router` instance
- **Rationale**: Centralized, testable, handler-based routing.

### 2. Route Naming
- **Choice**: `/` for home, `/movie/:id` for details, `/search` for search
- **Rationale**: Clean URL-like structure, parameter extraction via Fluro's route params.

### 3. main.dart Structure
- **Choice**: ProviderScope wrapping MaterialApp with router and theme
- **Rationale**: Riverpod DI available throughout the widget tree.

## Risks / Trade-offs

- [Risk] Fluro is less maintained than go_router → documented in ADR with migration path
