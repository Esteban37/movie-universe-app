## 1. Shared Widgets (Core)

- [x] 1.1 [Flutter] Create `SkeletonLoader` widget with `SkeletonVariant` enum (card, detail, text) and shimmer animation
- [x] 1.2 [Flutter] Create `ContentState<T>` generic widget wrapping `AsyncValue.when` with skeleton/error/empty/data states
- [x] 1.3 [Flutter] Create `HeroBackdrop` widget with gradient overlay supporting configurable gradient stops and scaffold background color
- [x] 1.4 Write unit tests for `SkeletonLoader` (variant rendering, shimmer animation lifecycle)
- [x] 1.5 Write unit tests for `ContentState` (loading, error, empty, data states with callbacks)
- [x] 1.6 Write unit tests for `HeroBackdrop` (gradient rendering, theme-aware color blending)



## 2. Dark Theme (Core)

- [x] 2.1 [Flutter] Define cinematic color palette constants (near-black background, Rappi red primary, cosmic purple secondary, teal tertiary, gold star-rating)
- [x] 2.2 [Flutter] Implement `AppTheme.dark()` with custom `ColorScheme.dark()` and component theme overrides (CardTheme, AppBarTheme, ChipTheme, InputDecorationTheme)
- [x] 2.3 [Flutter] Refactor `AppTheme.light()` to share `TextTheme` and `ShapeTheme` with dark variant
- [x] 2.4 [Flutter] Create `themeModeProvider` as `StateProvider<ThemeMode>` with dark default
- [x] 2.5 [Flutter] Wire `themeModeProvider` into `MaterialApp` (theme, darkTheme, themeMode parameters in main.dart)
- [x] 2.6 Write unit tests for theme provider (default value, switching)
- [x] 2.7 Write widget tests for theme switching (app renders in both themes without errors)

## 3. Immersive Detail Screen (Presentation)

- [x] 3.1 [Flutter] Create `_ImmersiveDetailView` stateful widget with `CustomScrollView` + `SliverPersistentHeader` delegate for collapsing backdrop
- [x] 3.2 [Flutter] Implement `SliverPersistentHeaderDelegate` composing three-layer Stack: backdrop image (parallax scale), gradient overlay (lerped stops), poster (positioned bottom-left)
- [x] 3.3 [Flutter] Implement scroll-driven `ValueNotifier<double>` from `ScrollController` mapping offset to collapse progress (0.0–1.0)
- [x] 3.4 [Flutter] Wire parallax backdrop scale via `Transform` lerped by collapse progress
- [x] 3.5 [Flutter] Wire gradient overlay opacity via `LinearGradient` color alpha, lerped by collapse progress
- [x] 3.6 [Flutter] Implement poster dual-widget cross-fade: header poster fades out, content poster fades in with size/radius transitions
- [x] 3.7 [Flutter] Implement app bar opacity transition: transparent → opaque, title fade-in, using collapse progress
- [x] 3.8 [Flutter] Staggered content reveal — PARTIAL / INTENTIONAL DEVIATION: the compact info row fades in on collapse (>0.45) to avoid duplicating the header, but genre chips and overview stay fully visible from first paint. A scroll-tied hide/reveal of primary content was dropped per explicit product feedback that movie information must be readable without scrolling (and because off-screen slivers mute tickers, an entrance fade never plays until scrolled into view anyway).
- [x] 3.9 [Flutter] Implement gesture-driven dismiss: `GestureDetector` on `CustomScrollView` with overscroll-down detection, transform (scale + translate), threshold-based completion
- [x] 3.10 [Flutter] Wire dismiss completion to `Navigator.of(context).pop` with route-compatible timing
- [x] 3.11 [Flutter] Integrate skeleton loading state: replace `LoadingView` with `SkeletonLoader.variant.detail` inside `ContentState`
- [x] 3.12 [Flutter] Implement responsive breakpoints: 300dp backdrop on phone (<600), 420dp on tablet (>=600)
- [x] 3.13 [Flutter] Implement reduced motion support: disable parallax, stagger, shimmer when `disableAnimations` is true
- [x] 3.14 [Flutter] Add semantic labels to backdrop, poster, and back button for accessibility (favorite/menu buttons removed: out of scope and non-functional)

## 4. Navigation Integration (Core)

- [x] 4.1 [Flutter] Verify Fluro navigation to detail screen works with new stateful immersive layout
- [x] 4.2 [Flutter] Ensure dismiss gesture `Navigator.pop` completes without double-animation conflict with Fluro route transition

## 5. Tests

- [x] 5.1 Write widget test for immersive detail screen in loading state (skeleton visible)
- [x] 5.2 Write widget test for immersive detail screen with mock data (header, poster, metadata, genres, overview visible)
- [x] 5.3 Write widget test for immersive detail screen error state (error view + retry)
- [x] 5.4 Write widget test for header collapse (scroll triggers app bar title appearance, gradient opacity change)
- [x] 5.5 Write widget test for dismiss gesture (drag threshold triggers pop, sub-threshold springs back)
- [x] 5.6 Write widget test for responsive layout (phone vs tablet backdrop height)
- [x] 5.7 Write widget test for reduced motion (animations disabled, content still renders)

## 6. Cleanup

- [x] 6.1 Remove deprecated `_MovieDetailContent` stateless widget if no longer referenced (no references remain)
- [x] 6.2 Verify no hardcoded colors remain in detail screen (all colors from theme; only `Colors.transparent` used for gradient endpoints)
- [x] 6.3 Run `dart analyze` across changed files and resolve all warnings (changed files clean; remaining infos are pre-existing `avoid_print` in logging_interceptor and `prefer_const_constructors` in an untouched test)
- [x] 6.4 Run existing unit tests to confirm no regressions (full suite: 106 passing)
