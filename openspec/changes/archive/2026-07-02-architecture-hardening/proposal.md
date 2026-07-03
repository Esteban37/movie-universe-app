# Architecture Hardening

## Summary

Harden Movie Universe toward Clean Architecture with feature-first layout, a shared design system, typed error handling, and automated layer-boundary tests — while preserving the premium immersive UI from `feat/premium-ui-redesign`.

## Scope

- Feature modules: `movies`, `search`
- Shared layers: `core/`, `shared/design_system/`, `shared/widgets/`
- Out of scope: TV Shows / Series (documented as planned in README)

## Decisions

| Decision | Rationale |
|----------|-----------|
| Use cases between UI and repositories | Testability, single-responsibility, scalable business logic |
| `TmdbMovieDto` in `core/data/` | Avoid cross-feature data coupling (search ↔ movies) |
| `MovieDisplayModel` in design system | Keep DS independent of feature domain entities |
| `PaginatedMoviesNotifier` base class | DRY for Popular / Top Rated infinite scroll |
| Typed `Failure` + `ErrorView.failure` | User-safe messages, no raw exceptions in UI |
| `PosterImage` / `BackdropImage` atoms | Centralize TMDB URL building via `TmdbImageUrl` |
| Fluro + `opaque: false` detail route | Preserve swipe-to-dismiss premium transition |

## Layer rules

```text
presentation → domain (use cases, entities via mappers)
domain ↛ data, presentation
data → domain (mapping only)
shared/design_system ↛ features/*
search/data ↛ movies/data
```

Enforced by `test/architecture/layer_boundaries_test.dart`.
