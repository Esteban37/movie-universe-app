## Context

The app follows Clean Architecture (feature-first) with `core/`, `features/<f>/{data,domain,presentation}/`, and `shared/`. It is functionally complete, but an audit of the "scalable + best practices" requirement found four structural gaps:

1. **Use cases are dead code for movies.** `lib/features/movies/domain/usecases/{get_popular_movies,get_top_rated_movies,get_movie_details}.dart` exist, but the providers in `lib/features/movies/presentation/providers/` call `MovieRepository` directly. Search, by contrast, goes through `search_movies.dart`. Inconsistent access path.
2. **Typed failures don't reach the UI.** `core/errors/failures.dart` defines a sealed `Failure`; `movie_repository_impl.dart` throws it, but list/detail error states render `error.toString()` → `Instance of 'NetworkFailure'`.
3. **Hardcoded values.** TMDB image URLs / size segments (`w780`, `w500`, `w342`, `w92`) are duplicated in `movie_card.dart`, `search_result_card.dart`, `movie_detail_screen.dart`; `Colors.amber` bypasses theme tokens.
4. **No design system.** UI lives under `features/*/presentation/widgets/` and inside `movie_detail_screen.dart` (~820 lines) as private, non-reusable widgets.

Constraints: refactor MUST be behavior-preserving; the existing test suite (108 tests) is the regression net; no new product features; no visual redesign.

## Goals / Non-Goals

**Goals:**
- Single, consistent business-logic entry point (use cases) for the movies feature, mirroring Search.
- Typed `Failure` propagated end-to-end and rendered as a friendly message via exhaustive `sealed` matching.
- A reusable atomic-design library under `lib/shared/design_system/` that the 3 existing screens (list, detail, search) compose from.
- Zero hardcoded image URLs and zero hardcoded color literals in widgets.
- Permanent guardrails encoded in `openspec/config.yaml` (`rules`) and `AGENTS.md`.

**Non-Goals:**
- i18n/localization, offline cache, Favorites, TV Shows, cast/similar — future changes.
- Changing Dio/interceptors/Fluro transport or the visual design from `premium-ui-redesign`.
- Introducing a new state-management or DI library.

## Decisions

### D1 — Wire use cases through new presentation providers
Add `useCase` providers (e.g., `getPopularMoviesProvider`, `getTopRatedMoviesProvider`, `getMovieDetailsProvider`) that depend on `movieRepositoryProvider`, and refactor `popular_movies_provider`, `top_rated_movies_provider`, `movie_details_provider` to invoke the use case instead of the repository.
- **Why:** Consistent with Search; keeps presentation decoupled from data; makes use cases the single testable business-logic seam.
- **Alternatives:** (a) Delete the movie use cases and let providers call the repository — rejected: diverges from Search and Clean Architecture intent. (b) Have widgets call use cases directly — rejected: breaks provider/state boundary.

### D2 — Surface typed failures with a presentation mapper
Providers keep their `AsyncValue` error as the original `Failure`. Add a presentation-side mapper (a `Failure`-typed `ErrorView`, or a `String message(Failure)` extension) that uses exhaustive `switch` over the sealed subtypes to produce the copy.
- **Why:** Preserves error typing for tests/analytics; the exhaustive `switch` guarantees new `Failure` subtypes force a compile-time update.
- **Alternatives:** Catch and rethrow generic strings in the provider — rejected: loses type; can't branch on cause (e.g., retry only network).

### D3 — Atomic design under `lib/shared/design_system/` (without visual regression)
Create `atoms/`, `molecules/`, `organisms/`, `templates/` for **shared reusable** pieces (RatingBadge, MovieCard, SearchResultCard, ErrorView). **Do NOT replace** the immersive `MovieDetailScreen` from `premium-ui-redesign` with a simplified layout — that screen's private widgets, parallax header, dismiss gesture, and scroll-tied animations are the canonical visual spec.
- **Why:** Reuse for list/search cards and shared states; premium detail stays the visual source of truth until a dedicated visual change spec says otherwise.
- **Alternatives:** Decompose detail screen into organisms in one pass — rejected: caused visual regression (lost theme, navigation, animations). Incremental extraction only when a visual spec explicitly requires it.

### D4 — Centralized TMDB image helper
Add `lib/core/media/tmdb_image.dart` exposing a size-aware builder (semantic sizes → TMDB segments) and null-safe handling. All image widgets consume it.
- **Why:** Removes duplicated literals; one place to change base URL/sizes; testable pure function.
- **Alternatives:** Constants in `api_constants.dart` only — partial; still lets widgets concatenate segments ad hoc.

### D5 — Guardrails in config + AGENTS.md
Encode standards (atomic-design placement, no hardcoded colors/image URLs, typed errors to UI, providers via use cases, test-with-implementation) into `openspec/config.yaml` `rules` and `AGENTS.md`.
- **Why:** Makes the standard persistent for every future change/spec, not a one-off.
- **Alternatives:** `custom_lint`/`dart_code_metrics` enforcement — complementary and can be added later; docs-level guardrails first to avoid tooling churn in this change.

## Risks / Trade-offs

- **Broad refactor touching many files** → Mitigation: phase by layer (use cases → errors → images/theme → design system), run `dart analyze` + full test suite after each phase; behavior-preserving only.
- **Design-system extraction may subtly change widget trees / break widget tests** → Mitigation: keep public rendering identical (same keys/semantics), add component tests before/while migrating, rely on existing screen tests.
- **Guardrails without lint tooling can drift** → Mitigation: keep them explicit and reviewable; leave a follow-up hook to add `custom_lint` rules.
- **Provider signature changes could ripple into tests/overrides** → Mitigation: preserve `movieRepositoryProvider` override seam so existing test setup keeps working; add use-case overrides only where needed.

## Migration Plan

1. **Phase 1 — Use cases:** add use-case providers; refactor 3 movie providers; update/confirm tests. `analyze` + full suite green.
2. **Phase 2 — Errors:** propagate `Failure`; add mapper + `ErrorView(Failure)`; update list/detail/search error states.
3. **Phase 3 — Images & theme tokens:** add `tmdb_image.dart`; replace URL literals; swap `Colors.amber` → `colorScheme.tertiary`.
4. **Phase 4 — Design system:** scaffold `design_system/` for shared atoms/molecules; **restore and preserve** `premium-ui-redesign` immersive detail + shared widgets; migrate cards only; run detail/list widget tests.
5. **Phase 5 — Guardrails & docs:** update `config.yaml` `rules`, `AGENTS.md`, and README features/AI-usage sections.

Rollback: each phase is an isolated, revertible commit; no data or API contract changes.

## Open Questions

- Should the `Failure`→message mapping live on `ErrorView` or as a `Failure` extension in `core/errors/`? (Leaning: extension in `core/errors/` for reuse; `ErrorView` accepts `Failure`.)
- Do we adopt `custom_lint` now to enforce guardrails, or defer to a follow-up change? (Leaning: defer.)
