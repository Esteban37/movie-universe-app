## Context

Movie Universe ships movies and movie-only search under Clean Architecture with a premium immersive detail experience (`premium-ui-redesign`). Architecture hardening introduced shared `TmdbMovieDto`, design-system display models, and documented four deferred gaps: TV Shows, search pagination, unused `MovieMetaRow`, and search→movies domain coupling.

This design extends the app to **movies + TV series** without sacrificing layer boundaries or cinematic UI. TMDB exposes parallel TV endpoints and a unified multi search endpoint that returns heterogeneous media types.

## Goals

- Full TV Shows feature mirroring movies (Popular, Top Rated, immersive detail)
- Shared `MediaItem` union consumed by search and cross-feature UI
- Unified search with type filter chips and infinite scroll pagination
- `MediaMetaRow` used in at least one non-immersive surface (compact preview / tablet master pane)
- Bottom navigation for discoverability and thumb reach
- Preserve: theme tokens, `TmdbImageUrl`, typed `Failure`, use-case-only providers, layer boundary tests

## Non-Goals

- Episode/season drill-down, favorites, offline, i18n, cast galleries
- Replacing Fluro or rebuilding movie detail from scratch
- Backend beyond TMDB REST

---

## UX / Information Architecture

### Shell: Bottom Navigation

```text
┌─────────────────────────────────────┐
│  AppBar (title + theme toggle)      │
├─────────────────────────────────────┤
│                                     │
│         Active tab content          │
│                                     │
├─────────────────────────────────────┤
│  🎬 Movies  │  📺 Series  │  🔍 Search │
└─────────────────────────────────────┘
```

| Tab | Content | Sub-navigation |
|-----|---------|----------------|
| Movies | Existing `MovieListScreen` (Popular / Top Rated) | Unchanged inner `TabBar` |
| Series | New `TvShowListScreen` (Popular / Top Rated) | Same grid + pagination pattern |
| Search | Enhanced `SearchScreen` | Filter chips: All · Movies · Series |

**Rationale:** Three top-level destinations scale cleanly; avoids a 2×2 tab matrix (media type × sort). Matches modern streaming apps (browse by catalog, dedicated search).

### Search UX

1. User types query → 500 ms debounce (unchanged)
2. `/search/multi` returns movies + TV; map to `MediaItem`
3. Filter chips narrow visible results client-side (no extra API call)
4. Scroll to bottom → load next page; append to list
5. Tap result → `pushMovieDetail` or `pushTvShowDetail` based on `mediaType`

Empty states:

- No query → illustration + hint text
- No results → `EmptyView` with query context
- Filter yields zero → "No series match …" (scoped message)

### TV Detail (Immersive)

Reuse movie detail architecture:

| Movie detail | TV detail equivalent |
|--------------|---------------------|
| `releaseDate` | `firstAirDate` |
| `runtime` min | `numberOfSeasons` seasons · `numberOfEpisodes` eps |
| `tagline` | `tagline` (same field) |
| Genres | Genres (`GenreChip`) |
| Backdrop parallax | Same `BackdropImage` + gradient |
| Swipe-to-dismiss | Same gesture protocol |

Additional TV-only metadata row (below title):

- **Status** chip: Returning Series · Ended · Canceled (mapped to theme `colorScheme`)
- **Networks** (if present): subtle text row, max 2 lines

Non-immersive fallback (tablet master-detail width ≥ 900 px):

- Left pane list item uses `MediaMetaRow` with seasons instead of runtime

### Visual Language

- Same cinematic palette, dark/light via `themeModeProvider`
- `MediaCard` extends current `MovieCard` layout: small type badge (film / TV icon) on poster corner
- Skeleton loaders: reuse `SkeletonVariant.card` and `.detail`
- No hardcoded colors; badge uses `colorScheme.secondaryContainer`

---

## Architecture

### Layer diagram (after change)

```text
presentation
├── movies/     → GetPopularMovies, GetMovieDetails, …
├── tv_shows/   → GetPopularTvShows, GetTvShowDetails, …
├── search/     → SearchMedia (multi), PaginatedSearchNotifier
└── shell/      → BottomNavScaffold

domain
├── movies/domain/entities/     MovieEntity, MovieDetailEntity
├── tv_shows/domain/entities/   TvShowEntity, TvShowDetailEntity
└── core/domain/entities/       MediaType, MediaItem (sealed union)

data
├── core/data/dtos/             TmdbMovieDto, TmdbTvShowDto
├── core/data/mappers/          TmdbMovieMapper, TmdbTvShowMapper
├── movies/data/                movie endpoints
├── tv_shows/data/              tv endpoints
└── search/data/                /search/multi

shared/design_system/
├── models/media_display_model.dart
├── molecules/media_card.dart
└── molecules/media_meta_row.dart
```

### Layer rules (updated)

```text
presentation → domain (use cases, MediaItem via mappers)
domain ↛ data, presentation
movies/domain ↛ tv_shows/domain (no cross-feature domain imports)
search/domain → core/domain (MediaItem only, not MovieEntity)
search/data ↛ movies/data, tv_shows/data
design_system ↛ features/*
```

Enforced by extending `test/architecture/layer_boundaries_test.dart`.

---

## Key Decisions

### 1. `MediaItem` as sealed Freezed union

```dart
@freezed
sealed class MediaItem with _$MediaItem {
  const factory MediaItem.movie(MovieEntity movie) = MovieMediaItem;
  const factory MediaItem.tvShow(TvShowEntity tvShow) = TvShowMediaItem;
}
```

- **Alternatives:** Common base class `MediaEntity` extended by Movie/TvShow — couples features in one inheritance tree; harder to evolve independently.
- **Rationale:** Wrapper keeps feature entities intact; exhaustive `switch` in UI; search returns homogeneous `List<MediaItem>`.

### 2. Feature-local entities, shared list DTOs

- `MovieEntity` / `TvShowEntity` stay in their feature domains
- List-item JSON shapes live in `core/data/dtos/` (already established for movies)
- Detail DTOs remain feature-local (`MovieDetailDto`, `TvShowDetailDto`)

### 3. Unified search via `/search/multi`

- **Alternatives:** Parallel `/search/movie` + `/search/tv` with merged UI — doubles debounced traffic; `/search/multi` is one round-trip.
- **Filter chips:** Client-side filter on cached `List<MediaItem>`; changing filter does not re-fetch page 1 unless query changed.
- **Pagination:** Pass `page` to multi search; map `media_type` field (`movie` | `tv`) when building `MediaItem`.

### 4. `PaginatedSearchNotifier` extends search state model

```dart
class SearchPageState {
  final List<MediaItem> items;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final MediaType? activeFilter; // null = All
}
```

- Debounce applies only to query changes (reset to page 1)
- `loadNextPage()` mirrors `PaginatedMoviesNotifier` guard flags

### 5. Bottom nav vs. nested tabs

- **Choice:** Bottom nav at root; each catalog keeps inner Popular/Top Rated tabs
- **Alternatives:** Single screen with 4 tabs — poor UX on phones; deep hierarchy

### 6. `MediaMetaRow` placement

- **Immersive detail:** Keep bespoke animated meta (movie: `ImmersiveMovieMetaRow`; TV: new `ImmersiveTvShowMetaRow` in feature presentation)
- **Non-immersive:** `MediaMetaRow` in tablet master pane list tile expansion and optional compact preview sheet
- Deprecate `MovieMetaRow` via export alias → `MediaMetaRow` for backward compatibility in tests

### 7. Navigation parity for TV detail

```dart
static Future<dynamic> pushTvShowDetail(BuildContext context, String id) {
  return FluroRouter.appRouter.navigateTo(
    context,
    '/tv/$id',
    transition: TransitionType.custom,
    transitionDuration: const Duration(milliseconds: 300),
    opaque: false,
    transitionBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
```

Same dismiss gesture and skeleton loading as movies.

### 8. Provider wiring (target)

```text
# TV Shows
tv_show_repository_provider.dart   → TvShowRepository
tv_show_usecase_providers.dart       → GetPopularTvShows, GetTopRatedTvShows, GetTvShowDetails
paginated_tv_shows_notifier.dart     → shared infinite-scroll base for TV list tabs
popular_tv_shows_provider.dart       → extends paginated base
top_rated_tv_shows_provider.dart     → extends paginated base
tv_show_details_provider.dart        → FutureProvider → GetTvShowDetails

# Search (updated)
search_repository_provider.dart      → SearchRepository
search_usecase_providers.dart        → searchMediaProvider (SearchMedia)
search_provider.dart                 → PaginatedSearchNotifier → searchMediaProvider
```

---

## TMDB Mapping Reference

| Use case | Endpoint | Key fields |
|----------|----------|------------|
| Popular TV | `GET /tv/popular` | id, name, poster_path, vote_average, first_air_date, overview |
| Top rated TV | `GET /tv/top_rated` | same |
| TV detail | `GET /tv/{id}` | + backdrop_path, genres, tagline, number_of_seasons, number_of_episodes, status, networks |
| Multi search | `GET /search/multi` | media_type, id, title/name, poster_path, vote_average, release_date/first_air_date |

---

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Multi search returns `person` entries | Filter out non-movie/non-tv `media_type` in mapper |
| Large refactor touches many files | Phased tasks: shared core → TV feature → search → shell |
| Duplicate paginated notifier logic | Extract generic `PaginatedListNotifier<T>` in core/presentation (optional refactor in same change) |
| TV backdrop aspect ratios differ | Same `BoxFit.cover` + `Alignment.topCenter` as movies |
| Breaking search tests | Update fixtures to multi JSON; keep debounce tests |
| `MovieDisplayModel` consumers | Typedef/export alias during migration; update design-system tests |

---

## Migration / Rollout

1. **Phase A — Shared core:** `MediaItem`, `TmdbTvShowDto`, `MediaDisplayModel` (no UI change)
2. **Phase B — TV feature:** Full vertical slice behind `/tv/:id`; list tab accessible via temporary route
3. **Phase C — Shell:** Bottom nav wires Movies + Series + Search
4. **Phase D — Search:** Multi search + pagination + filter chips; remove `MovieEntity` from search domain
5. **Phase E — Polish:** `MediaMetaRow` in tablet layout; architecture tests; docs

Each phase keeps `flutter test` green.

## Verification

```bash
flutter test
flutter test test/architecture/
dart run dependency_validator
openspec validate media-universe-expansion --strict
```
