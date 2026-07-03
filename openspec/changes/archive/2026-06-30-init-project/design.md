## Context

Greenfield Flutter project with no existing code. This change establishes the foundational structure that all subsequent features will build upon.

## Goals / Non-Goals

**Goals:**
- Create standard Flutter directory layout per Clean Architecture + Feature First
- Declare all required dependencies in `pubspec.yaml`
- Set up environment variable loading for TMDB API credentials
- Configure `build_runner` and analysis options

**Non-Goals:**
- No business logic code
- No feature implementations
- No widget code

## Decisions

### 1. Directory Structure
- **Choice**: `lib/` with `core/`, `features/`, `shared/`, `main.dart`
- **Rationale**: Feature First scales better. Each feature contains data/domain/presentation. Core holds cross-cutting concerns. Shared holds reusable widgets.

### 2. State Management: Riverpod vs BLoC
- **Choice**: flutter_riverpod
- **Rationale**: Compile-safe providers, no BuildContext dependency, AsyncValue for loading/error states, easier testing via overrides.

### 3. Networking: Dio vs http
- **Choice**: dio
- **Rationale**: Interceptor pipeline (auth, logging, retry), timeout, cancellation, better error handling.

### 4. Code Generation: Freezed
- **Choice**: freezed + json_serializable + build_runner
- **Rationale**: Immutable models, generated copyWith/==/hashCode, JSON serialization, pattern matching.

### 5. Navigation: Fluro vs go_router
- **Choice**: fluro
- **Rationale**: Specified in requirements. Centralized route definitions, argument passing, handler-based.

## Risks / Trade-offs

- [Risk] Freezed code generation adds build step complexity → Mitigation: `build_runner watch` mode, clear `.gitignore` for generated files
- [Trade-off] Feature First means some code duplication across features vs Layer First
