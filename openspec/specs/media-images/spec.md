# media-images Specification

## Purpose

Centralized TMDB image URL construction and design-system image atoms. All network image URLs MUST go through `TmdbImageUrl` in `lib/core/media/tmdb_image.dart`; widgets use `PosterImage` / `BackdropImage`.
## Requirements
### Requirement: Centralized TMDB image URL construction
The project SHALL construct all TMDB image URLs through a single, size-aware helper. Widgets SHALL NOT hardcode image base URLs or size segments.

#### Scenario: Build an image URL by semantic size
- **WHEN** a widget needs a poster or backdrop image URL
- **THEN** it SHALL request it from the centralized helper specifying a semantic size (e.g., poster small/medium/large, backdrop)
- **AND** the helper SHALL return the fully-qualified TMDB image URL for the corresponding TMDB size segment

#### Scenario: No hardcoded image URLs in widgets
- **WHEN** any widget renders a network image
- **THEN** it SHALL NOT contain a literal `https://image.tmdb.org/...` base URL
- **AND** it SHALL NOT contain a raw size segment such as `w500`, `w780`, `w342`, or `w92`

#### Scenario: Missing image path handled
- **WHEN** an image path is null or empty
- **THEN** the helper SHALL signal the absence of an image
- **AND** the widget SHALL render its placeholder / errorBuilder instead of a broken URL

