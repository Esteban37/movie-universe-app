## Context

The Movie Detail screen is currently a flat `SingleChildScrollView` + `Column` with a fixed-height backdrop (200px), no gradient overlay, no animations, and no dismiss gesture. It renders data but provides no cinematic experience. This design delivers an immersive, scroll-driven detail screen inspired by Apple TV, Netflix, and Letterboxd while working within the existing architecture (Fluro routing, Riverpod state, Clean Architecture layers).

## Goals / Non-Goals

**Goals:**
- Collapsing header with parallax backdrop, dynamic gradient, and repositioning poster
- Scroll-driven animations: header collapse, gradient fade, app bar opacity, content stagger
- Gesture-driven dismiss: overscroll down from top shrinks the screen and pops the route
- Skeleton shimmer loading state replacing CircularProgressIndicator
- Dark theme with cinematic color palette and ThemeMode switching via Riverpod
- 60fps performance using hardware-accelerated Transform layers
- Reusable shared widgets: skeleton loader, hero backdrop, content state wrapper
- Full test coverage for new widgets and the refactored screen

**Non-Goals:**
- No shared element hero transition (Fluro limitation — layout-based visual continuity instead)
- No changes to domain entities, data layer, or existing providers
- No changes to the movie list, search, or other screens
- No offline caching, favorites, or cast details
- No changes to the routing library (Fluro remains)

## Decisions

### 1. Scroll Architecture: SliverPersistentHeader over SliverAppBar

- **Choice**: `CustomScrollView` with `SliverPersistentHeader` delegate
- **Alternatives considered**: `SliverAppBar` (built-in but lacks independent layer control); `NestedScrollView` (too opinionated for custom animations)
- **Rationale**: `SliverAppBar` can't independently control backdrop scale, gradient opacity, and poster position — all three need separate lerp values from the same scroll offset. A custom `SliverPersistentHeaderDelegate` gives one `build()` method with full `shrinkOffset` control, letting us compose the three layers (backdrop, gradient, poster) in a single `Stack` with lerped properties.
- **Testability**: The delegate's `build` method is a pure function of `shrinkOffset` and `overlapsContent` — easily unit-testable.

### 2. Animation Driver: ScrollController ValueNotifier over AnimationController

- **Choice**: `ScrollController` listener writes to a `ValueNotifier<double>` (0.0 = expanded, 1.0 = collapsed). Widgets read via `AnimatedBuilder`/`ValueListenableBuilder`.
- **Alternatives considered**: `AnimationController` driven by scroll (requires `ScrollController` + manual mapping); `ScrollPosition` directly in widgets (tight coupling)
- **Rationale**: The scroll position IS the animation input — there's no time-based animation for the collapse. A `ValueNotifier` avoids `setState` rebuilds of the entire widget tree; only listeners rebuild. The dismiss gesture uses a separate `AnimationController` (spring-based) because that IS time-based.
- **Performance**: `ValueListenableBuilder` rebuilds are scoped to the widgets that depend on the value. Backdrop scale, gradient opacity, and poster position each get their own builder.

### 3. Gradient Overlay: ShaderMask-less Approach

- **Choice**: `Container` with `BoxDecoration(LinearGradient)` positioned absolutely, with gradient stops lerped via `collapseProgress`
- **Alternatives considered**: `ShaderMask` (GPU gradient, but creates a saveLayer per frame); `BackdropFilter` (requires saveLayer, expensive)
- **Rationale**: A plain `Container` with a `LinearGradient` in `BoxDecoration` does NOT create a saveLayer — Flutter draws it inline with the painting. Lerping gradient stops via `Alignment.lerp` and `colors` array mutation is free. The opacity fade is achieved by shifting the alpha channel of the gradient colors, not by wrapping in an `Opacity` widget.
- **Impact**: The gradient blends the backdrop into the scaffold background color at full expansion, then fades to transparent as the header collapses. At full collapse, the gradient is fully transparent and the header is hidden.

### 4. Poster Repositioning: Single Widget with Interpolated Position

- **Choice**: One `Positioned` widget inside the header's `Stack`, with top/left/width/height lerped between expanded and collapsed states. A second "ghost" poster in the content area below fades in as the header poster fades out.
- **Alternatives considered**: Two poster widgets cross-fading (risk of visual mismatch); `Hero` widget (incompatible with Fluro); AnimatedWidget (more code, same result)
- **Rationale**: Two widgets with an opacity cross-fade is simpler and visually identical to a single widget moving. The header poster has `opacity: 1.0 - collapseProgress`; the content poster has `opacity: collapseProgress`. At any point, one is fully visible, so there's no overlapping semi-transparent ghost effect. The poster image URL is the same, so there's no visual discontinuity.
- **Radius transition**: `BorderRadius.lerp(8px, 4px, collapseProgress)` — poster corner radius shrinks as it moves into the content area.

### 5. Gesture Dismiss: Local UI Transform over Custom Route

- **Choice**: A `GestureDetector` wrapping the `CustomScrollView` transforms the scaffold content during overscroll. On completion, calls `FluroRouter.appRouter.pop(context)`.
- **Alternatives considered**: `PageRouteBuilder` with custom transition (breaks Fluro pattern); `DraggableScrollableSheet` (wrong interaction model); `ModalBottomSheet` (wrong visual model)
- **Rationale**: The dismiss gesture is a local UI animation — the screen visually shrinks and slides down. At the end, we just pop the route (which happens instantly because the content is already gone). Fluro's route animation never plays; the user sees only the UI-level shrink. The route pop is a no-op visually. The Scaffold background becomes transparent during the gesture so the movie list behind is visible.
- **Gesture protocol**: Only activates when `scrollOffset == 0` AND initial touch moves downward. The drag offset maps to progress (0.0–1.0). Release above 0.3 threshold triggers dismiss animation (200ms easeIn). Below threshold triggers spring-back (300ms easeOut).

### 6. Dark Theme: Dual ThemeData with Shared Typography

- **Choice**: `AppTheme.dark()` and `AppTheme.light()` as static methods sharing a single `TextTheme` and `ShapeTheme`. Theme mode selected via Riverpod `StateProvider<ThemeMode>`.
- **Alternatives considered**: Single `ThemeData.withBrightness()` (loses customization); InheritedWidget (reinventing the wheel)
- **Rationale**: Material 3's `useMaterial3: true` + `brightness: Brightness.dark` handles 90% of color inversion. The custom color scheme (near-black background, Rappi red primary, cosmic purple secondary, teal tertiary) is applied via `ColorScheme.dark()`. Shared `TextTheme` ensures zero layout shift when switching themes — only colors change.
- **Persistence**: Theme preference persisted to `SharedPreferences` (future enhancement — for now, default to dark).

### 7. Loading State: Skeleton over Spinner

- **Choice**: `SkeletonLoader` widget with `SkeletonVariant.card`, `.detail`, `.text` constructors
- **Alternatives considered**: Shimmer package (dependency); CustomPaint (more code for same result)
- **Rationale**: A skeleton loader renders the shape of the content before data arrives, reducing perceived latency. The shimmer is a `LinearGradient` animated via `Transform.translate` in a repaint boundary — no saveLayer, no layout rebuilds. Three variants match the three loading contexts: card grids (poster shape + text lines), detail (backdrop shape + metadata), text-only (paragraph lines).

### 8. Animation Curves and Timings

| Animation | Curve | Duration | Rationale |
|-----------|-------|----------|-----------|
| Header collapse (scroll) | None (linear) | Scroll-driven | Follows finger directly |
| Dismiss drag (follow finger) | None (linear) | Input-driven | One-to-one tracking |
| Dismiss spring-back (cancel) | `easeOutCubic` | 300ms | Fast exit, natural deceleration |
| Dismiss commit (close) | `easeInCubic` | 200ms | Quick, doesn't linger |
| Content stagger fade | `easeOut` | 400ms | One element at a time, 100ms offset |
| Skeleton shimmer sweep | `linear` | 1.5s loop | Continuous, non-distracting |

## Risks / Trade-offs

- [Risk] Fluro cannot use `Hero` widget for shared element transitions → **Mitigation**: Layout-based visual continuity (matching poster position, size, and elevation between MovieCard and detail screen header)
- [Risk] ScrollController listener + GestureDetector overlap may cause gesture conflicts → **Mitigation**: Primary scroll gesture wins when scrolling; dismiss gesture only activates at `scrollOffset == 0`
- [Risk] TMDB backdrop images vary in quality/aspect ratio → **Mitigation**: `fit: BoxFit.cover` with `Alignment.topCenter` — always crops from top (faces/skyline)
- [Risk] Skeleton shimmer with `cached_network_image` may flash on fast networks → **Mitigation**: 500ms minimum skeleton display before fading in content
- [Trade-off] Dark theme prioritized over light — light theme will be functional but less polished
- [Trade-off] Poster cross-fade (two widgets) vs. single moving widget — cross-fade is simpler to implement and debug; the visual difference is imperceptible at 60fps
