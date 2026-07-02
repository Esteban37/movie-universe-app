import 'package:flutter/material.dart';

class FloatingDetailAppBar extends StatelessWidget {
  const FloatingDetailAppBar({
    super.key,
    required this.backdropUrl,
    required this.title,
    required this.collapseProgress,
    required this.onBack,
  });

  final String? backdropUrl;
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
                if (backdropUrl != null)
                  Opacity(
                    opacity: backgroundImageOpacity,
                    child: Image.network(
                      backdropUrl!,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(
                      alpha: backdropUrl == null
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
                    // Balances the leading back button so the title stays
                    // visually centered. Favorite/menu actions were removed:
                    // they are out of scope for the exercise and were non-functional.
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
