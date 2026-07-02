/// Layout and animation constants for the immersive movie detail experience.
abstract final class ImmersiveDetailConstants {
  static const phoneHeaderHeight = 300.0;
  static const tabletHeaderHeight = 420.0;
  static const phoneBreakpoint = 600.0;
  static const expandedPosterWidth = 120.0;
  static const expandedPosterHeight = 180.0;
  static const contentPosterWidth = 80.0;
  static const contentPosterHeight = 120.0;

  // Poster cross-fade window (in header collapse progress). The header poster
  // shrinks to the content poster size by [posterCrossoverStart], then fades
  // out over [posterCrossoverSpan] while the content poster fades in over an
  // overlapping window, producing a "same relative position" hand-off.
  static const posterCrossoverStart = 0.35;
  static const posterCrossoverSpan = 0.20;
  static const contentPosterFadeStart = 0.40;
  static const contentPosterFadeSpan = 0.22;
}
