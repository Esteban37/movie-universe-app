# Changelog

## documentation-alignment

- **README slimmed** to project essentials: features, stack, AI usage, setup, doc index.
- **Extended `docs/`:** `architecture.md`, `runtime-design.md` (API/network/state; formerly `sdd.md`), `roadmap.md`, `openspec.md`, `docs/README.md`.
- Clarified **SDD = Spec-Driven Development** (AI methodology via OpenSpec); renamed `sdd.md` → `runtime-design.md` to avoid acronym clash.
- Documented SDD + OpenSpec rationale: structured change lifecycle and cross-model evaluation under the same specs and verification gate.
- README preview section with dark-theme screenshots under `docs/assets/screenshots/` (`movies-home.png`, `movie-detail.png`, `search-unified.png`, `tv-home.png`).
- Bilingual README: `README.md` (Spanish, primary) and `README.en.md` (English); technical docs remain in English under `docs/`.
- README requirements table: fixed markdown, added detail-scroll row, inline summary for favorites/offline/i18n (full detail in `docs/roadmap.md`).
- OpenSpec fixes: `shared-media-domain` → `lib/shared/domain/` + `MediaReference`; `pagination` → `PaginatedMediaNotifier`; `architecture` → shared templates; `testing` → integration + CI; `media-images` Purpose.
- Removed `openspec/` and `AGENTS.md` from `.gitignore`.
- Aligned `AGENTS.md` molecule list and OpenSpec workflow notes.
- Renamed `docs/Testing_Strategy.md` → `docs/testing-strategy.md` (lowercase convention).
- Added [`docs/ai-usage.md`](ai-usage.md): SDD (Spec-Driven Development) + OpenSpec methodology, Git/PR strategy, tools/models, manual verification gate.
- Slimmed README AI usage section; detail moved to `docs/ai-usage.md`.

## project-hygiene-and-shared-abstractions

- Updated `pubspec.yaml` description to reflect the TMDB media-discovery app.
- Added `riverpod` to `dev_dependencies` for test-only `ProviderContainer` helpers.
- Moved `MediaItem` and `MediaType` from `lib/core/domain/` to `lib/shared/domain/` so core no longer depends on feature entities.
- Introduced `PaginatedMediaNotifier<T>` in `lib/shared/presentation/providers/`; movie and TV list tabs now share one pagination base.
- Extracted `ImmersiveDetailViewTemplate` in `lib/shared/presentation/detail/`; movie and TV immersive detail screens delegate scroll, parallax, and swipe-to-dismiss behavior to the shared template.
- Full test suite — **213 tests** pass (210 unit/widget + 3 integration).
- GitHub Actions CI: `flutter pub get`, `build_runner`, `dart analyze --fatal-warnings`, `dart run dependency_validator`, `flutter test`, `flutter test integration_test`.
- `MediaReference` + `shared/domain` barrel for scalable cross-feature catalog growth.
- `ImmersiveDetailHeaderDelegate` design-system template; feature headers delegate to it.
- Integration tests: Movies / Series / Search shell tabs → detail navigation.

## testing-setup

- Created `test/helpers/test_fixtures.dart` with sample DTO/entity factory methods and JSON fixtures.
- Created `test/helpers/provider_container.dart` with `createTestContainer` for Riverpod provider tests.
- Ran `dart analyze` and fixed lint issues (`unused_imports`, `sort_constructors_first`, `prefer_const_constructors`).
- Ran full test suite — all 79 tests pass at the time.
- Added `test/features/search/domain/entities/search_result_entity_test.dart` for previously untested `SearchResultEntity`.
- Created `docs/testing-strategy.md` documenting test structure and conventions.
