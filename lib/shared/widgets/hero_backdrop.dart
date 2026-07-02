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
  });

  final String imageUrl;
  final double height;
  final double collapseProgress;
  final Color? backgroundColor;
  final String? semanticLabel;

  /// When false, only a top vignette is applied so the bottom edge stays
  /// fully opaque — useful inside a collapsing [SliverPersistentHeader].
  final bool fadeToBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBg = backgroundColor ?? theme.scaffoldBackgroundColor;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              1.0 + (1.0 - collapseProgress) * 0.05,
              1.0 + (1.0 - collapseProgress) * 0.05,
              1.0,
            ),
            child: Semantics(
              label: semanticLabel,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: theme.colorScheme.surfaceContainerHighest),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                  );
                },
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
            scaffoldBg,
          ],
          stops: const [0.0, 0.35, 0.7, 1.0],
        ),
      ),
    );
  }
}
