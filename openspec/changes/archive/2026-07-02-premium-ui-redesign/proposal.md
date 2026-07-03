## Why

The current Movie Detail screen is a flat, static layout (SingleChildScrollView + Column with hardcoded paddings, no animations, no gradient overlay, no dismiss gesture). This fails to deliver the cinematic, premium feel expected by users of modern streaming and gallery apps. The detail screen is the highest-engagement page — it's where users decide whether to watch a movie. An immersive experience here directly impacts perceived app quality, retention, and brand perception.

## What Changes

**Movie Detail Screen — Complete Visual and Interaction Redesign**

- Replace the flat `SingleChildScrollView` layout with a `CustomScrollView` + `SliverPersistentHeader` architecture
- Introduce an animated collapsing header with parallax backdrop, dynamic gradient overlay, and a repositioning poster that smoothly transitions from hero position to inline content position
- Add scroll-driven animations: backdrop scale, gradient opacity fade, app bar opacity, content stagger-fade
- Implement a gesture-driven dismiss interaction: overscroll downward from the top of the page triggers a shrink + slide animation, then closes the screen — revealing the movie list underneath
- Replace the loading spinner with an animated skeleton shimmer matching the final content shape
- Add hero-style shared element visual continuity from movie card poster to detail backdrop (via coordinated layout, not Flutter Hero widget — Fluro limitation)
- All animations target 60fps using hardware-accelerated transforms, avoid Opacity widget saveLayers, and follow Material Motion principles

**Dark Theme Support**

- Add a dark theme (`ThemeData` with `Brightness.dark`) using the cinematic color palette (near-black backgrounds, cosmic purple secondary, Rappi red primary)
- Wire `ThemeMode` switching via a Riverpod `StateProvider<ThemeMode>`
- Detail screen gradient overlay and backdrop styling adapts to active theme

**Component Additions**

- `lib/shared/widgets/skeleton_loader.dart`: Reusable shimmer skeleton with card/detail/text variants
- `lib/shared/widgets/hero_backdrop.dart`: Reusable hero backdrop with gradient overlay
- `lib/shared/widgets/content_state.dart`: Wrapper widget eliminating `AsyncValue.when` boilerplate across screens

**No Breaking Changes** — Existing screens, providers, repositories, entities, and routes remain unchanged. Only the detail screen presentation layer is rewritten.

## Capabilities

### New Capabilities

- `immersive-detail-ui`: Collapsing header, parallax backdrop, dynamic gradient, scroll-driven animations, gesture-driven dismiss, skeleton loading for the movie detail screen
- `dark-theme`: Dark theme configuration with cinematic color palette, theme mode switching, and theme-aware component styling

### Modified Capabilities

- `movie-details-ui`: Requirements expanded beyond basic data display to include immersive animations, responsive hero treatment, and gesture dismiss
- `shared-widgets`: Expanded to include skeleton loader, hero backdrop, and content state wrapper patterns
- `responsive-ui`: Detail screen responsive behavior formalized with distinct phone/tablet layouts (single-column scroll vs. two-column master-detail)

## Impact

- **lib/features/movies/presentation/screens/movie_detail_screen.dart** — Full rewrite from 152 lines (static) to ~350 lines (immersive with animations)
- **lib/core/theme/app_theme.dart** — Add dark theme alongside existing light theme, add component theme overrides
- **lib/shared/widgets/** — 3 new files: `skeleton_loader.dart`, `hero_backdrop.dart`, `content_state.dart`
- **lib/core/router/app_router.dart** — Minor: ensure route animation accommodates the new dismiss gesture (no breaking change)
- **lib/main.dart** — Wire `ThemeMode` provider to `MaterialApp` (themeMode parameter)
- **No changes** to domain entities, data layer, repositories, providers, or existing list screens
