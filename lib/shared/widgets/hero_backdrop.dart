import 'package:flutter/material.dart';

class HeroBackdrop extends StatelessWidget {
  const HeroBackdrop({
    super.key,
    required this.imageUrl,
    required this.height,
    this.collapseProgress = 0.0,
    this.backgroundColor,
    this.semanticLabel,
    this.fadeToBackground = true,
    this.enableParallax = true,
    this.fadeBackdropOnCollapse = true,
    this.gradientStops,
  });

  final String imageUrl;
  final double height;
  final double collapseProgress;
  final Color? backgroundColor;
  final String? semanticLabel;

  /// When false, only a top vignette is applied so the bottom edge stays
  /// fully opaque — useful inside a collapsing [SliverPersistentHeader].
  final bool fadeToBackground;
  final bool enableParallax;

  /// When true, the backdrop image opacity lerps from 1.0 to 0.0 as the header
  /// collapses, blending it away into the scaffold background.
  final bool fadeBackdropOnCollapse;

  /// Optional custom gradient stops for the fade-to-background overlay. When
  /// null, sensible defaults are used.
  final List<double>? gradientStops;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBg = backgroundColor ?? theme.scaffoldBackgroundColor;
    final backdropOpacity = fadeBackdropOnCollapse
        ? (1.0 - collapseProgress).clamp(0.0, 1.0)
        : 1.0;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: backdropOpacity,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                enableParallax ? 1.0 + (1.0 - collapseProgress) * 0.05 : 1.0,
                enableParallax ? 1.0 + (1.0 - collapseProgress) * 0.05 : 1.0,
                1.0,
              ),
              child: Semantics(
                label: semanticLabel,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: _buildGradient(scaffoldBg, collapseProgress),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradient(Color scaffoldBg, double progress) {
    if (!fadeToBackground) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.45 * (1.0 - progress)),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5],
          ),
        ),
      );
    }

    final alpha = (0.85 * (1.0 - progress)).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3 * (1.0 - progress)),
            scaffoldBg.withValues(alpha: alpha),
            scaffoldBg.withValues(alpha: alpha),
          ],
          stops: gradientStops ?? const [0.0, 0.35, 0.7, 1.0],
        ),
      ),
    );
  }
}
