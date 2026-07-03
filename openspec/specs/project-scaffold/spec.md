# Project Scaffold

## Purpose

Establish the foundational Flutter project structure, dependency management, build configuration, and environment setup that all features build upon.

## Requirements

### Requirement: Standard Flutter directory structure
The project SHALL follow a Clean Architecture + Feature First directory layout.

#### Scenario: lib/ directory exists
- **WHEN** the project is scaffolded
- **THEN** the `lib/` directory SHALL contain `core/`, `features/`, `shared/`, and `main.dart`

#### Scenario: core/ subdirectories exist
- **WHEN** the project is scaffolded
- **THEN** `lib/core/` SHALL contain `constants/`, `network/`, `router/`, `errors/`, `theme/`, `extensions/`, `utils/`

#### Scenario: features/ structure exists
- **WHEN** the project is scaffolded
- **THEN** `lib/features/` SHALL be ready for feature modules, each with `data/`, `domain/`, `presentation/` subdirectories

### Requirement: Dependencies declared
The project SHALL declare all required dependencies in `pubspec.yaml`.

#### Scenario: pubspec.yaml contains all dependencies
- **WHEN** `flutter pub get` is run
- **THEN** `pubspec.yaml` SHALL include flutter_riverpod, dio, freezed, fluro, build_runner, mocktail

### Requirement: Environment configuration
The project SHALL support loading TMDB API credentials from a `.env` file.

#### Scenario: .env file provides TMDB token
- **WHEN** the application loads environment variables
- **THEN** the TMDB_ACCESS_TOKEN SHALL be available from the `.env` file

### Requirement: Code generation configured
The project SHALL have build_runner configured for Freezed code generation.

#### Scenario: build_runner generates code
- **WHEN** `dart run build_runner build` is executed
- **THEN** Freezed and JsonSerializable classes SHALL be generated
