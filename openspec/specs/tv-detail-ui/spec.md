## Purpose

Immersive TV show detail screen matching the premium movie detail experience: collapsing header, parallax backdrop, swipe-to-dismiss, and skeleton loading.

## Requirements

### Requirement: Immersive TV detail screen
A `TvShowDetailScreen` SHALL present TV show details with the same interaction model as `MovieDetailScreen`.

#### Scenario: Collapsing header with parallax
- **WHEN** the user scrolls the detail content
- **THEN** the backdrop SHALL parallax and collapse using a `CustomScrollView` + sliver header architecture

#### Scenario: Swipe-to-dismiss gesture
- **WHEN** the user overscrolls downward from the top at scroll offset zero
- **THEN** the screen SHALL animate shrink/slide dismiss
- **AND** pop the route via Fluro on completion

#### Scenario: Non-opaque route
- **WHEN** navigating to TV detail
- **THEN** the route SHALL use `opaque: false` so the list remains visible during dismiss

#### Scenario: Skeleton loading
- **WHEN** TV detail data is loading
- **THEN** the screen SHALL show `SkeletonLoader` with detail variant
- **AND** it SHALL NOT show a bare `CircularProgressIndicator`

### Requirement: TV detail content
Detail content SHALL surface TV-specific metadata with design-system components.

#### Scenario: Genres displayed with GenreChip
- **WHEN** genres are present
- **THEN** the detail SHALL render `GenreChip` widgets
- **AND** it SHALL NOT use raw Material `Chip`

#### Scenario: Seasons and episodes metadata
- **WHEN** detail data includes season and episode counts
- **THEN** the screen SHALL display them in human-readable form (e.g., "3 seasons · 24 episodes")

#### Scenario: Status and networks
- **WHEN** status or networks are present
- **THEN** the detail SHALL display status as a themed chip and networks as secondary text

#### Scenario: Backdrop and poster images
- **WHEN** images are rendered
- **THEN** the screen SHALL use `BackdropImage` and `PosterImage` via `TmdbImageUrl`

### Requirement: TV detail error handling
Failed detail loads SHALL use typed failure messaging.

#### Scenario: Error state on detail fetch failure
- **WHEN** getTvShowDetails fails
- **THEN** the screen SHALL show `ErrorView.failure` with retry
- **AND** display `Failure.message` to the user

### Requirement: Visual preservation
TV detail implementation SHALL NOT regress premium-ui-redesign patterns established for movies.

#### Scenario: Theme-aware styling
- **WHEN** the user toggles dark/light mode
- **THEN** TV detail colors SHALL come from `Theme.of(context).colorScheme` and `textTheme`
- **AND** no hardcoded color literals SHALL be introduced except semantically neutral values

#### Scenario: Shared premium widgets retained
- **WHEN** TV detail renders async states
- **THEN** it SHALL use shared widgets from `hero_backdrop.dart`, `content_state.dart`, and `skeleton_loader.dart` where applicable

#### Scenario: Shared immersive detail primitives
- **WHEN** TV detail renders its app bar overlay and header constants
- **THEN** it SHALL use shared widgets under `lib/shared/presentation/detail/` and `lib/shared/widgets/floating_detail_app_bar.dart`
- **AND** it SHALL NOT import movie presentation widgets directly
