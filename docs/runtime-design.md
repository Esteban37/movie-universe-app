# Runtime Design

API integration, networking, state management, and error handling for Movie Universe.

Structural layout and module boundaries: [architecture.md](architecture.md).

---

## API — The Movie Database (TMDB)

- Base URL and token from `.env` (`TMDB_BASE_URL`, bearer token).
- Documentation: https://developer.themoviedb.org/

| Feature | Endpoints (examples) |
|---------|----------------------|
| Movies | `/movie/popular`, `/movie/top_rated`, `/movie/{id}` |
| TV | `/tv/popular`, `/tv/top_rated`, `/tv/{id}` |
| Search | `/search/multi` |

Authentication: Bearer token in request headers via Dio interceptors.

---

## Networking (Dio)

Located in `lib/core/network/`.

- **Interceptors** — auth header, logging (debug)
- **Timeouts** — connect/receive limits
- **Retry** — `RetryInterceptor` for transient failures (not offline cache)
- **Error mapping** — exceptions → typed `Failure` in repository layer

Assumptions: live internet required for catalog data; rate limits enforced by TMDB.

---

## State management (Riverpod)

```text
UI (Screen / Widget)
    → ref.watch(notifierProvider | futureProvider)
Provider / AsyncNotifier
    → ref.read(useCaseProvider).call(...)
Use Case
    → Repository (contract)
Repository Implementation
    → RemoteDataSource → TMDB
```

- **Repository providers** — DI wiring only (`*_repository_provider.dart`).
- **Use-case providers** — expose domain operations (`*_usecase_providers.dart`).
- **UI notifiers** — call use cases, never repositories directly.

`flutter_hooks` is not used; Riverpod alone handles state management.

---

## Navigation (Fluro)

- Central router: `lib/core/router/app_router.dart`
- Shell: bottom tabs via `AppShell` (Movies · Series · Search)
- Detail routes: `opaque: false` + fade transition for immersive movie/TV detail

---

## Error handling

Typed failures in `lib/core/errors/failures.dart`:

| Failure | Typical cause |
|---------|----------------|
| `NetworkFailure` | No connectivity / connection error |
| `TimeoutFailure` | Request timeout |
| `ServerFailure` | HTTP 5xx |
| `NotFoundFailure` | Missing resource |

Presentation MUST surface `Failure.message` via `ErrorView.failure` or `failureUserMessage` — never raw `error.toString()` for domain failures.

Handled cases: no internet, API errors, timeouts, empty responses, unexpected exceptions (generic user message).

---

## Media images

All TMDB image URLs built through `TmdbImageUrl` in `lib/core/media/tmdb_image.dart`.

- Widgets use `PosterImage` / `BackdropImage` design-system atoms.
- No hardcoded `https://image.tmdb.org/...` or size segments in UI code.

---

## Theming

- `AppTheme.dark()` / `AppTheme.light()` — cinematic palette
- `themeModeProvider` — user toggle dark/light
- Widgets use `Theme.of(context).colorScheme` / `textTheme` (no hardcoded colors except transparent gradient stops)

---

## Accessibility

- Semantic labels where applicable
- Support for dynamic text scaling
- Responsive layouts (list grids, detail scroll)
- Screen reader–friendly structure on primary flows

---

## Assumptions

- Valid TMDB API token required.
- Internet required for live catalog (offline planned — see [roadmap.md](roadmap.md)).
- Scalability prioritized over fastest path to MVP.
