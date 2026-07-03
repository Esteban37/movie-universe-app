# Media Universe Expansion — Tasks

## Phase A — Shared media core

### Core domain

- [x] Create `lib/core/domain/entities/media_type.dart` (`movie`, `tvShow`)
- [x] Create `lib/core/domain/entities/media_item.dart` (sealed Freezed union wrapping feature entities)
- [x] Add unit tests for `MediaItem` mapping helpers / exhaustiveness

### Core data

- [x] Create `lib/core/data/dtos/tmdb_tv_show_dto.dart` (Freezed + JsonSerializable)
- [x] Create `lib/core/data/mappers/tmdb_tv_show_mapper.dart` → `TvShowEntity`
- [x] Add JSON fixture tests for `TmdbTvShowDto`

### Design system — shared models

- [x] Create `lib/shared/design_system/models/media_display_model.dart` (`mediaType`, `subtitle`)
- [x] Add `MediaDisplayMapper` in `lib/shared/mappers/`
- [x] Deprecate direct `MovieDisplayModel` usage via export alias (keep backward compat)

---

## Phase B — TV Shows feature

### [Flutter] Domain layer (`lib/features/tv_shows/domain/`)

- [x] Create `tv_show_entity.dart` (id, name, posterPath, voteAverage, firstAirDate, overview)
- [x] Create `tv_show_detail_entity.dart` (+ backdropPath, genres, tagline, seasons, episodes, status, networks)
- [x] Create `tv_show_repository.dart` abstract contract
- [x] Create use cases: `GetPopularTvShows`, `GetTopRatedTvShows`, `GetTvShowDetails`
- [x] Unit tests for use cases

### [Flutter] Data layer (`lib/features/tv_shows/data/`)

- [x] Create `tv_show_detail_dto.dart` for `/tv/{id}` response
- [x] Create `tv_show_remote_datasource.dart` (popular, top_rated, detail)
- [x] Create `tv_show_repository_impl.dart` with DTO→entity mapping
- [x] Unit tests: DTO serialization, datasource (mock Dio), repository

### [Flutter] Presentation layer (`lib/features/tv_shows/presentation/`)

- [x] `tv_show_repository_provider.dart` — DI only
- [x] `tv_show_usecase_providers.dart` — expose use cases
- [x] `paginated_tv_shows_notifier.dart` — mirror `PaginatedMoviesNotifier`
- [x] `popular_tv_shows_provider.dart`, `top_rated_tv_shows_provider.dart`
- [x] `tv_show_details_provider.dart` — FutureProvider
- [x] `tv_show_list_screen.dart` — Popular / Top Rated tabs, responsive grid
- [x] `tv_show_detail_screen.dart` — immersive detail (parallax, dismiss, skeleton)
- [x] Feature widgets: `tv_show_card.dart`, `immersive_tv_show_meta_row.dart`, detail delegates
- [x] Provider tests with repository override seam
- [ ] Widget tests: list → detail navigation, scroll pagination

---

## Phase C — Navigation shell

- [x] Create `lib/shared/presentation/shell/app_shell.dart` (BottomNavigationBar)
- [x] Wire Movies | Series | Search tabs preserving `themeModeProvider` in AppBar
- [x] Register `/tv/:id` in `app_router.dart`
- [x] Add `AppRouter.pushTvShowDetail` (opaque: false, fade)
- [x] Update navigation widget tests

---

## Phase D — Unified search & pagination

### Domain & data

- [x] Rename/refactor use case: `SearchMedia` (replaces movie-only `SearchMovies`)
- [x] Update `SearchResultEntity` → `List<MediaItem>` + pagination fields
- [x] Update `SearchRemoteDataSource` → `/search/multi`; filter `media_type`
- [x] Update `SearchRepositoryImpl` mapping
- [x] Unit tests with multi-search JSON fixtures

### Presentation

- [x] Refactor `SearchNotifier` → `PaginatedSearchNotifier` (debounce + infinite scroll)
- [x] Add filter chips: All | Movies | Series (client-side filter)
- [x] Update `SearchScreen` to use `MediaCard` and dual detail navigation
- [x] Provider tests: debounce, pagination guards, filter, empty/error states
- [x] Widget tests: search flow, filter chips, load-more indicator

---

## Phase E — Design system activation & decoupling

- [x] Create `media_card.dart` (type badge, uses `MediaDisplayModel`)
- [x] Create `media_meta_row.dart` (rating, date, runtime OR seasons/episodes)
- [x] Use `MediaMetaRow` in tablet master pane / compact preview (non-immersive)
- [x] Remove `MovieEntity` imports from `search/domain` and `search/presentation`
- [x] Extend `test/architecture/layer_boundaries_test.dart` for new rules
- [x] Widget tests: `MediaCard`, `MediaMetaRow`

---

## Phase F — Documentation & validation

- [x] Update `AGENTS.md` provider wiring (tv_shows, unified search)
- [x] Update `README.md` features list (TV Shows implemented)
- [x] Run `dart run dependency_validator`
- [x] Run `openspec validate media-universe-expansion --strict`
- [ ] Archive completed delta specs to `openspec/specs/` on merge

---

## Deferred (explicit out of scope)

- [ ] Episode list / season detail screens
- [ ] Favorites across movies and series
- [ ] Search history
- [ ] Golden / integration tests for full flows
- [ ] OpenSpec CLI in CI
- [ ] TV list → detail navigation widget tests
