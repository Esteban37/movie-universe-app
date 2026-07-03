## 1. Networking Layer

- [x] 1.1 Create `core/network/api_constants.dart` with TMDB base URL, endpoints, and timeouts
- [x] 1.2 Create `core/network/dio_client.dart` with Dio singleton factory
- [x] 1.3 Implement `core/network/interceptors/auth_interceptor.dart` (Bearer token injection)
- [x] 1.4 Implement `core/network/interceptors/logging_interceptor.dart` (request/response logging)
- [x] 1.5 Implement `core/network/interceptors/retry_interceptor.dart` (exponential backoff, max 3 retries)
- [x] 1.6 Create `core/network/dio_provider.dart` Riverpod provider for Dio instance
- [x] 1.7 Write unit tests for auth interceptor
- [x] 1.8 Write unit tests for logging interceptor
- [x] 1.9 Write unit tests for retry interceptor
- [x] 1.10 Write unit test for Dio client configuration

## 2. Error Handling

- [x] 2.1 Create `core/errors/failures.dart` with sealed Failure class and subtypes (NetworkFailure, ServerFailure, TimeoutFailure, UnexpectedFailure)
- [x] 2.2 Create `core/errors/error_handler.dart` mapping DioExceptions to Failure types
- [x] 2.3 Write unit tests for error handler

## 3. Shared Widgets

- [x] 3.1 Create `shared/widgets/loading_view.dart` with centered CircularProgressIndicator
- [x] 3.2 Create `shared/widgets/error_view.dart` with error message and retry button
- [x] 3.3 Create `shared/widgets/empty_view.dart` with custom message display

## 4. Theme

- [x] 4.1 Create `core/theme/app_theme.dart` with Material 3 light theme

## 5. Utilities

- [x] 5.1 Create `core/utils/debouncer.dart` for debounced operations
- [x] 5.2 Create `core/constants/app_constants.dart` with shared app constants
