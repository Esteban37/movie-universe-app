# 🎬 Movie Universe

🇬🇧 English version · **[README en español](README.md)**

Flutter app to discover popular, top-rated, and searchable **movies and TV series** via [The Movie Database (TMDB)](https://developer.themoviedb.org/) — **immersive UI**, unified search, and a feature-first **Clean Architecture** foundation with **Riverpod**; **213 automated tests**.

![CI](https://github.com/Esteban37/movie-universe-app/actions/workflows/ci.yml/badge.svg?branch=main)
![Flutter](https://img.shields.io/badge/Flutter-3.35.7+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)
![Tests](https://img.shields.io/badge/tests-213%20passing-brightgreen)
![Architecture](https://img.shields.io/badge/Clean_Architecture-feature--first-blue)
![Theme](https://img.shields.io/badge/theme-dark%20%26%20light-111111)

---

## Preview

*Dark theme — cinematic UI across primary flows.*

| Movies | Immersive detail | Unified search | TV Series |
|:------:|:----------------:|:--------------:|:---------:|
| ![Movies home in dark theme](docs/assets/screenshots/movies-home.png) | ![Immersive movie detail in dark theme](docs/assets/screenshots/movie-detail.png) | ![Unified search in dark theme](docs/assets/screenshots/search-unified.png) | ![TV Series home in dark theme](docs/assets/screenshots/tv-home.png) |
| Popular & Top Rated | Parallax · swipe-to-dismiss | Movies + Series · pagination | Same list UX |

Light/dark toggle via `themeModeProvider`.

---

## Highlights

- Three-tab shell (Movies · Series · Search) with infinite scroll
- Immersive detail — collapsing header, parallax, shared premium template
- Unified search with in-memory filter chips
- Dark-first UI in screenshots; light mode supported
- Typed errors, design system, layer-boundary tests, GitHub Actions CI

---

## Features

### Implemented

| Feature | Status |
|-------------|--------|
| Popular & Top Rated (movies + series) | ✅ |
| Immersive detail | ✅ |
| Search by name | ✅ Unified + filters |
| Automated tests | ✅ Repos, use cases, DTOs, providers, widget & integration |
| List → detail | ✅ Widget + integration tests |
| Scroll on lists | ✅ Infinite pagination (movies, series, search) |
| Scroll on details | ✅ Header collapse, parallax, swipe-to-dismiss (widget tests) |
| Scalable architecture | ✅ Clean Architecture, CI |

Also: light/dark theme, typed error handling.

### Phase 2 — optional enhancements

Planned for a **future product iteration**; the current architecture supports them without a redesign.

Favorites, UI localization, offline cache, similar titles, cast, push notifications, golden tests.

**Summary approach:**

- **Favorites** — `favorites/` feature with local persistence; `MediaReference` + lightweight snapshot; fourth shell tab.
- **Offline** — composite repositories (remote + local cache); detail and loaded list pages first.
- **Localization** — UI copy (tabs, errors, labels) via `flutter_localizations` + ARB; domain unchanged.

Full detail: [`docs/roadmap.md`](docs/roadmap.md).

---

## Tech stack

| Technology | Role |
|------------|------|
| **Flutter 3.35.7+** | Project SDK (verified: **3.44.3**) |
| **Dart 3.12.2** | `sdk: ^3.12.2` in `pubspec.yaml` — Dart **bundled with** the Flutter SDK; version numbers differ from Flutter (there is no “Dart 3.35.7”, often confused with the Flutter version) |
| **Riverpod** | State management (no Hooks) |
| **Freezed** | Immutable models |
| **Fluro** | Navigation |
| Dio | TMDB API |
| Mocktail | Test mocks |

See [`docs/architecture.md`](docs/architecture.md) · [`docs/runtime-design.md`](docs/runtime-design.md).

---

## Getting started

**Requirements:** Flutter **3.35.7+** (verified: 3.44.3) · Dart **`^3.12.2`** (verified: 3.12.2) — see [Tech stack](#tech-stack) for Dart version detail.

```bash
git clone https://github.com/Esteban37/movie-universe-app.git
cd movie-universe-app
flutter pub get
dart run build_runner build --delete-conflicting-outputs

cp .env.development.example .env.development
cp .env.development .env
# Edit .env.development: set TMDB_ACCESS_TOKEN (see .env.example)

flutter run
```

```bash
flutter test
flutter test integration_test
```

> **`build_runner` is required on a fresh clone** — generated `*.freezed.dart` files are gitignored.

---

## Documentation

README is **bilingual**; everything under `docs/` is in **English** (architecture, OpenSpec, engineering conventions). Same files linked from both READMEs.

| Document | Content |
|----------|---------|
| [`docs/architecture.md`](docs/architecture.md) | Layers, structure, providers |
| [`docs/runtime-design.md`](docs/runtime-design.md) | API, networking, state, errors |
| [`docs/testing-strategy.md`](docs/testing-strategy.md) | Tests and CI |
| [`docs/ai-usage.md`](docs/ai-usage.md) | SDD, OpenSpec, Git, verification |
| [`docs/roadmap.md`](docs/roadmap.md) | Planned features |
| [`docs/openspec.md`](docs/openspec.md) | OpenSpec workflow |
| [`AGENTS.md`](AGENTS.md) | Engineering conventions and guardrails |

Full index: [`docs/README.md`](docs/README.md).

---

## AI usage

> **Approach:** **Spec-driven** development with **OpenSpec** and **SDD**: I defined the architecture (feature-first Clean Architecture, design system, layer tests), per-change scope, and acceptance criteria in specs and `tasks.md`. AI **accelerated** implementation, tests, and documentation drafts **from that contract** — OpenCode and Cursor, different models, same quality bar. I reviewed each delivery before merge: task-aligned diff, `dart analyze --fatal-warnings`, automated test suite, and manual UX review.

### Why SDD + OpenSpec?

**SDD** bounds AI work to **specs and directions I set**, not open-ended prompts. In the OpenCode phase I used **Context7 MCP** and **official Flutter/Dart skills** to ground the model on current library docs. **OpenSpec** enabled **comparing models** under the same checklist before each merge.

### What architectural decisions did I define?

I defined and iteratively refined:

- **Architecture:** Clean Architecture, feature-first, `shared/domain`, use cases, repository contracts
- **Patterns:** Repository, Riverpod DI, shared pagination, immersive templates, Atomic Design
- **Scalability:** cross-feature decoupling, incremental OpenSpec changes, `feat/*` + PR workflow
- **Practices:** typed errors, layer-boundary tests, CI, dependency validation, premium UI preservation

AI **proposed implementations** within that frame; I **adjusted, rejected, or rewrote** when output did not match the agreed design.

### Who decides what?

| | Author (human) | AI (assistant) |
|---|:---:|:---:|
| Architecture, patterns, scalability, best practices | ✅ Define & refine | Scoped suggestions / implementation |
| Scope, UX, priorities | ✅ | — |
| Merge approval to `main` | ✅ | — |
| Reject or fix bad output | ✅ | — |
| Code/tests/docs from specs | — | ✅ |
| Execute `tasks.md` items | — | ✅ |

### What is validated before each merge?

Each change: `tasks.md` alignment · `dart analyze --fatal-warnings` · `flutter test` · `flutter test test/architecture/` · `dart run dependency_validator` · manual review · **explicit merge decision**. AI proposes; **merge is human sign-off**.

### How is this traced in Git?

One OpenSpec change ≈ one `feat/*` branch ≈ one PR → `main`. The history reflects **reviewed incremental deliveries**, not a single AI-generated dump.

**[Full detail → `docs/ai-usage.md`](docs/ai-usage.md)**

---

## Author

**Esteban Serrano** — Senior Mobile Software Engineer
