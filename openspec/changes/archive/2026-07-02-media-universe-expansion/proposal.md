# Media Universe Expansion

## Summary

Expand Movie Universe into a unified **Media Universe** by adding TV Shows / Series, introducing shared domain primitives (`MediaItem`), decoupling search from movie-specific entities, enabling optional search pagination, and activating `MediaMetaRow` for non-immersive layouts — all while preserving Clean Architecture, the premium immersive UI, and existing design-system conventions.

## Problem Statement

The app currently covers movies only. Four architectural and product gaps block a cohesive multi-media experience:

1. **TV Shows / Series** — No feature module, routes, or TMDB TV endpoints; users cannot browse or inspect series.
2. **Search pagination** — Search loads a single page; long result sets truncate without infinite scroll.
3. **`MovieMetaRow` unused** — A design-system molecule exists but no screen consumes it; it is movie-specific and cannot serve TV metadata (seasons, first air date).
4. **Domain coupling in search** — `SearchResultEntity` and `SearchNotifier` depend on `MovieEntity` from the movies feature, which is acceptable for movies-only but breaks layer intent once series are added.

This change addresses all four gaps in one coordinated expansion so shared abstractions land before or alongside the TV feature, avoiding a second refactor.

## What Changes

### Shared media layer

- Introduce `MediaType` enum and sealed `MediaItem` wrapper in `lib/core/domain/entities/`
- Add `TmdbTvShowDto` + `TmdbTvShowMapper` in `lib/core/data/` (parallel to `TmdbMovieDto`)
- Generalize `MovieDisplayModel` → `MediaDisplayModel` with `mediaType` and flexible subtitle
- Rename/evolve `MovieMetaRow` → `MediaMetaRow` supporting movie runtime and TV season/episode counts

### TV Shows feature (`lib/features/tv_shows/`)

- Domain: `TvShowEntity`, `TvShowDetailEntity`, `TvShowRepository`, use cases (`GetPopularTvShows`, `GetTopRatedTvShows`, `GetTvShowDetails`)
- Data: remote datasource (`/tv/popular`, `/tv/top_rated`, `/tv/{id}`), repository impl, DTO mapping via core types
- Presentation: list screen (Popular / Top Rated tabs), immersive detail screen mirroring movie detail patterns, Riverpod providers wired through use cases

### Search evolution

- Replace movie-only search with **unified multi search** via TMDB `/search/multi` (movies + TV in one flow)
- Refactor `SearchResultEntity` to expose `List<MediaItem>` instead of `List<MovieEntity>`
- Add `PaginatedSearchNotifier` with debounce + infinite scroll (reuse pagination patterns from `PaginatedMoviesNotifier`)
- Search UI: content-type filter chips (All | Movies | Series), `MediaCard` results, navigation to correct detail route

### Navigation & shell

- Bottom navigation shell: **Movies** | **Series** | **Search** (modern, thumb-friendly)
- New routes: `/tv/:id`, `AppRouter.pushTvShowDetail` (same opaque-false fade as movies)
- Preserve existing movie routes and immersive transitions

## Capabilities

### New Capabilities

| Capability | Description |
|------------|-------------|
| `shared-media-domain` | `MediaItem`, `MediaType`, core DTOs/mappers for TV list items |
| `tv-shows-domain` | TV entities, repository contract, use cases |
| `tv-shows-data` | TMDB TV endpoints, repository implementation |
| `tv-shows-ui` | List screen, paginated providers, grid cards |
| `tv-detail-ui` | Immersive TV detail (seasons, status, networks, parallax header) |
| `unified-search` | Multi search, `MediaItem` results, type filter chips |
| `search-pagination` | Infinite scroll for search results |
| `media-design-system` | `MediaDisplayModel`, `MediaCard`, `MediaMetaRow` |

### Modified Capabilities

| Capability | Delta |
|------------|-------|
| `app-navigation` | Bottom nav shell, TV detail route, search route integration |
| `design-system` | Generalize card/meta models; keep premium visuals |
| `movie-search` | Superseded by `unified-search` requirements (archived delta) |
| `pagination` | Extend pattern to search notifier |

## Non-Goals

- Favorites, offline cache, watchlist, or local persistence
- Episode-level detail screens or season episode lists (future change)
- Cast / crew credits beyond a summary line on detail
- Similar / recommended media carousels
- Push notifications, localization (i18n), golden tests
- Replacing Fluro or rewriting movie immersive detail from scratch
- Renaming the app package or repository name (`movie_universe_app` stays)

## Impact

| Area | Files / modules |
|------|-----------------|
| Core domain | `lib/core/domain/entities/media_item.dart`, `media_type.dart` |
| Core data | `lib/core/data/dtos/tmdb_tv_show_dto.dart`, `mappers/tmdb_tv_show_mapper.dart` |
| Design system | `media_display_model.dart`, `media_card.dart`, `media_meta_row.dart` |
| New feature | `lib/features/tv_shows/{data,domain,presentation}/` |
| Search refactor | `search_result_entity.dart`, providers, screen, datasource → `/search/multi` |
| Navigation | `app_router.dart`, new `main_shell.dart` or `app_scaffold.dart` |
| Tests | Unit + widget + architecture boundary updates |
| Docs | `AGENTS.md`, `README.md` provider wiring section |

## Decisions

| Decision | Rationale |
|----------|-----------|
| Sealed `MediaItem` wrapper (not inheritance from `MovieEntity`) | Avoid breaking movies domain; search and UI consume one union type |
| `TmdbTvShowDto` in `core/data/` | Same cross-feature decoupling rationale as `TmdbMovieDto` |
| TMDB `/search/multi` | Single debounced request for mixed results; filter client-side by `MediaType` |
| Bottom navigation shell | Scales to Movies + Series + Search without nested tab overload |
| Reuse immersive detail architecture for TV | Visual parity, proven UX, satisfies premium-ui-redesign preservation |
| `MediaMetaRow` on compact list previews / tablet master pane | Activates unused molecule; immersive detail keeps custom meta layout |
| Incremental `MovieDisplayModel` → `MediaDisplayModel` migration | Deprecate alias export during transition; design system stays feature-agnostic |

## References

- README.md — Planned Improvements: TV Shows
- `openspec/changes/architecture-hardening/` — deferred TV Shows, search pagination
- `AGENTS.md` — Clean Architecture, provider wiring, visual preservation rules
- TMDB API v3: `/tv/popular`, `/tv/top_rated`, `/tv/{tv_id}`, `/search/multi`
