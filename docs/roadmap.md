# Roadmap

**Phase 2** — optional product enhancements planned for a **future iteration**; the codebase is structured so they can be added without redesigning Clean Architecture.

How each item would be implemented on top of the current architecture:

---

## Favorites

```text
features/favorites/
  domain/       → FavoritesRepository, ToggleFavorite, GetFavorites
  data/         → local datasource (Hive / Drift / SharedPreferences + JSON)
  presentation/ → FavoritesScreen, favorites providers
```

- Persist **`MediaReference(id, MediaType)`** from `lib/shared/domain/` plus a lightweight snapshot (`title`, `posterPath`) for list rendering without a network call.
- Toggle from detail or list via a use case; **remote repositories stay unchanged**.
- Add a fourth tab in `AppShell` (`shared/presentation/shell/`).
- Reuse `MediaCard` / `MediaDisplayModel` for the favorites list UI.

---

## Offline cache

Today the app is **online-first**: repositories call remote datasources only; `RetryInterceptor` handles transient failures but does not cache catalog data.

```text
Repository (composite)
  ├── RemoteDataSource  → when online
  └── LocalDataSource   → cache / fallback when offline
```

Suggested rollout:

1. **Detail pages** recently viewed (best offline UX).
2. **List pages** already loaded (popular/top-rated pages in memory + disk).
3. **Search** — cache query history locally; TMDB search results offline is optional/low priority.

- Optional `ConnectivityService` in `core/network/` or `core/storage/`.
- **Domain contracts unchanged** — only repository implementations gain a local layer.
- Favorites stored locally pair naturally with offline favorites list display.

---

## Localization (i18n)

Translate **UI copy** (tabs, buttons, errors, empty states) — not TMDB content, which follows API language settings.

- Add `flutter_localizations` + `intl`, `l10n.yaml`, ARB files under `lib/l10n/`.
- Replace user-facing strings in presentation layer; keep domain/errors keys or localized message mappers in presentation.
- No change to feature module layout.

---

## Similar movies / cast details

- New feature modules or sub-routes under existing features:
  - `features/movies/` — `GetSimilarMovies`, similar section in detail or dedicated screen.
  - `features/cast/` (optional) — person detail from TMDB `/person/{id}`.
- Follow existing pattern: datasource → repository → use case → provider → screen.
- Reuse immersive detail template where layout matches.

---

## Push notifications

- Out of scope for TMDB catalog app unless product adds watchlists/reminders.
- Would integrate FCM + local notification scheduling; favorites/watchlist feature is a prerequisite.

---

## Golden tests

- Snapshot tests for design-system atoms/molecules and key list/detail layouts.
- Run in CI separately from integration tests; pin `flutter test --update-goldens` workflow for intentional UI changes.

---

## Related

- Current architecture: [architecture.md](architecture.md)
- OpenSpec baseline: [openspec.md](openspec.md)
