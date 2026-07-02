import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/atoms/backdrop_image.dart';

class FloatingDetailAppBar extends StatelessWidget {
  const FloatingDetailAppBar({
    super.key,
    required this.backdropPath,
    required this.imageUrls,
    required this.title,
    required this.collapseProgress,
    required this.onBack,
  });

  final String? backdropPath;
  final TmdbImageUrl imageUrls;
  final String title;
  final double collapseProgress;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    final backgroundOpacity = collapseProgress.clamp(0.0, 1.0);
    final titleOpacity = ((collapseProgress - 0.6) / 0.4).clamp(0.0, 1.0);
    final backgroundImageOpacity = ((collapseProgress - 0.35) / 0.35).clamp(
      0.0,
      1.0,
    );
    final foregroundColor = Color.lerp(
      colorScheme.onPrimary,
      colorScheme.onSurface,
      backgroundOpacity,
    )!;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Semantics(
        container: true,
        child: ClipRect(
          child: SizedBox(
            height: topPadding + kToolbarHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (backdropPath != null)
                  Opacity(
                    opacity: backgroundImageOpacity,
                    child: BackdropImage(
                      path: backdropPath,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      imageUrls: imageUrls,
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(
                      alpha: backdropPath == null
                          ? backgroundOpacity
                          : backgroundOpacity * 0.72,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.shadow.withValues(
                          alpha: backgroundImageOpacity * 0.20,
                        ),
                        colorScheme.surface.withValues(
                          alpha: backgroundOpacity * 0.30,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: NavigationToolbar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: foregroundColor),
                      onPressed: onBack,
                      tooltip: 'Back',
                    ),
                    middle: Text(
                      title,
                      key: const ValueKey('collapsed-app-bar-title'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(
                          alpha: titleOpacity,
                        ),
                      ),
                    ),
                    trailing: const SizedBox(width: 48),
                    centerMiddle: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
