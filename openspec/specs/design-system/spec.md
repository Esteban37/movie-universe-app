# design-system Specification

## Purpose

Shared Atomic Design component library under `lib/shared/design_system/`. Components are feature-agnostic (use `MediaDisplayModel` / display props, not feature entities). Premium immersive detail visuals from `premium-ui-redesign` must be preserved during structural refactors.

## Requirements
### Requirement: Atomic design component library
The project SHALL provide a shared design system organized by atomic-design layers under `lib/shared/design_system/` (`atoms/`, `molecules/`, `organisms/`, `templates/`).

#### Scenario: Layered component organization
- **WHEN** a reusable UI component is created
- **THEN** it SHALL be placed in the correct atomic layer (`atoms/`, `molecules/`, `organisms/`, or `templates/`)

#### Scenario: Atoms are primitive and stateless
- **WHEN** an atom (e.g., RatingBadge, GenreChip, PosterImage, BackdropImage, ErrorView) is defined
- **THEN** it SHALL be a small, single-responsibility, reusable widget
- **AND** it SHALL NOT contain feature-specific or business logic

#### Scenario: Molecules compose atoms
- **WHEN** a molecule (e.g., MediaMetaRow, MovieCard, MediaCard) is defined
- **THEN** it SHALL be composed from atoms and/or simpler molecules
- **AND** it SHALL NOT import feature domain entities directly

#### Scenario: Templates share immersive detail behavior
- **WHEN** a collapsing detail header is needed for movie or TV detail
- **THEN** feature-specific delegates SHALL compose `ImmersiveDetailHeaderDelegate` in `lib/shared/design_system/templates/`
- **AND** scroll/dismiss/parallax behavior SHALL live in `ImmersiveDetailViewTemplate` under `lib/shared/presentation/detail/`

### Requirement: Premium UI visual preservation during architecture refactors
Architecture refactors SHALL NOT alter the visual design, theme, navigation transitions, or animations delivered by `premium-ui-redesign` (`feat/premium-ui-redesign`).

#### Scenario: Immersive detail screen preserved
- **WHEN** architecture refactors touch movie or TV detail features
- **THEN** immersive detail screens SHALL retain collapsing header, parallax backdrop, poster cross-fade, swipe-to-dismiss gesture, and scroll-tied content behavior
- **AND** they SHALL NOT be replaced by a simplified `Scaffold` + static `AppBar` layout

#### Scenario: Theme and navigation preserved
- **WHEN** architecture refactors touch theming or routing
- **THEN** dark/light `ThemeMode` switching via `themeModeProvider` SHALL remain active
- **AND** detail navigation SHALL use `AppRouter.pushMovieDetail` / `AppRouter.pushTvShowDetail` with Fluro `opaque: false` and fade transition

#### Scenario: Shared premium widgets preserved
- **WHEN** architecture refactors touch shared presentation widgets
- **THEN** `hero_backdrop.dart`, `content_state.dart`, and `skeleton_loader.dart` from `premium-ui-redesign` SHALL remain in use
- **AND** architecture changes (typed errors, centralized image URLs) SHALL be applied without removing animations or visual behavior

#### Scenario: Components are independently testable
- **WHEN** a design-system component is added
- **THEN** it SHALL have a widget test that exercises its rendering in isolation
