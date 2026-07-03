## Why

The Movie Universe project needs a standardized Flutter foundation before any feature work begins. This change creates the project scaffold including directory structure, dependencies, environment configuration, and documentation skeleton — establishing conventions that all subsequent features will follow.

## What Changes

- Create `lib/` directory with Clean Architecture + Feature First layout
- Create `test/` mirroring `lib/` structure
- Create `docs/` with SDD, architecture, ADR, backlog, roadmap, changelog
- Configure `pubspec.yaml` with all required dependencies
- Set up `.env` loading for TMDB API token
- Configure `build_runner` for Freezed code generation
- Set up `.gitignore`, analysis_options.yaml

## Capabilities

### New Capabilities
- `project-scaffold`: Standard directory structure, build configuration, and dependency management

### Modified Capabilities
None.

## Impact

- New Flutter project structure under `lib/`, `test/`, `docs/`
- Dependencies added: flutter_riverpod, dio, freezed, fluro, build_runner, mocktail
- Environment file `.env` with TMDB_ACCESS_TOKEN required
- Build runner configuration for code generation
