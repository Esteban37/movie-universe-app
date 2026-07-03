## Purpose

Generalize design-system display models and molecules to support both movies and TV series, activating `MediaMetaRow` for non-immersive layouts.

## Requirements

### Requirement: MediaDisplayModel
The design system SHALL provide `MediaDisplayModel` as the feature-agnostic display type for cards and list rows.

#### Scenario: Model includes media type
- **WHEN** a `MediaDisplayModel` is constructed
- **THEN** it SHALL include id, title, posterPath, voteAverage, subtitle, and mediaType

#### Scenario: Design system independence
- **WHEN** inspecting design-system model files
- **THEN** they SHALL NOT import feature domain entities

### Requirement: MediaCard molecule
A `MediaCard` molecule SHALL render poster, title, rating, subtitle, and a media-type badge.

#### Scenario: MediaCard composes atoms
- **WHEN** `MediaCard` is built
- **THEN** it SHALL compose `PosterImage` and `RatingBadge`
- **AND** it SHALL NOT use raw `Image.network`

#### Scenario: Type badge distinguishes movie and TV
- **WHEN** mediaType is movie
- **THEN** the card SHALL show a movie indicator
- **WHEN** mediaType is tvShow
- **THEN** the card SHALL show a TV indicator

#### Scenario: Theme tokens only
- **WHEN** `MediaCard` applies colors and typography
- **THEN** it SHALL use `Theme.of(context).colorScheme` and `textTheme`

### Requirement: MediaMetaRow molecule
A `MediaMetaRow` molecule SHALL replace `MovieMetaRow` as the shared metadata row for non-immersive layouts.

#### Scenario: Movie metadata display
- **WHEN** MediaMetaRow receives movie metadata
- **THEN** it SHALL show rating, release date, and runtime in minutes when runtime is provided

#### Scenario: TV metadata display
- **WHEN** MediaMetaRow receives TV metadata
- **THEN** it SHALL show rating, first air date, and season/episode counts when provided

#### Scenario: MediaMetaRow composes RatingBadge
- **WHEN** MediaMetaRow renders rating
- **THEN** it SHALL use the `RatingBadge` atom

### Requirement: MediaMetaRow adoption
At least one non-immersive screen surface SHALL use `MediaMetaRow`.

#### Scenario: Tablet master pane uses MediaMetaRow
- **WHEN** the app layout width is at or above the tablet master-detail breakpoint
- **THEN** the master pane preview for selected media SHALL render `MediaMetaRow`

#### Scenario: Immersive detail does not require MediaMetaRow
- **WHEN** viewing immersive movie or TV detail on phone
- **THEN** feature-specific immersive meta rows MAY be used instead of `MediaMetaRow`

### Requirement: Backward compatibility
Existing `MovieDisplayModel` and `MovieMetaRow` consumers SHALL migrate without breaking public API during the change.

#### Scenario: Deprecation alias
- **WHEN** legacy code imports `MovieDisplayModel`
- **THEN** a deprecation export alias MAY remain until all call sites migrate to `MediaDisplayModel`

### Requirement: Widget tests
New and updated design-system media components SHALL have isolated widget tests.

#### Scenario: MediaCard widget test
- **WHEN** `MediaCard` is added
- **THEN** a widget test SHALL verify rendering for movie and TV variants

#### Scenario: MediaMetaRow widget test
- **WHEN** `MediaMetaRow` is added
- **THEN** a widget test SHALL verify movie runtime and TV seasons rendering
