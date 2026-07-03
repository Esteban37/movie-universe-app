import 'package:flutter/material.dart';

/// Horizontal meta row tuned for the immersive detail header and compact row.
///
/// Stacks vertically when horizontal space is tight (e.g. phone header beside
/// the poster) and flows horizontally with [Wrap] on wider layouts.
class ImmersiveMovieMetaRow extends StatelessWidget {
  const ImmersiveMovieMetaRow({
    super.key,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    this.lightText = false,
  });

  static const _compactLayoutMaxWidth = 240.0;

  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final bool lightText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedColor = lightText
        ? colorScheme.onPrimary.withValues(alpha: 0.85)
        : colorScheme.onSurfaceVariant;

    final ratingStyle = theme.textTheme.labelLarge?.copyWith(
      color: lightText ? colorScheme.onPrimary : null,
    );
    final metaStyle = theme.textTheme.bodyMedium?.copyWith(color: mutedColor);

    final rating = Semantics(
      label: 'Rating ${voteAverage.toStringAsFixed(1)} out of 10',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 18, color: colorScheme.tertiary),
          const SizedBox(width: 4),
          Text(voteAverage.toStringAsFixed(1), style: ratingStyle),
        ],
      ),
    );

    final date = Text(
      releaseDate,
      style: metaStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final runtimeLabel =
        runtime > 0 ? Text('$runtime min', style: metaStyle) : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompactLayout =
            constraints.maxWidth < _compactLayoutMaxWidth;

        if (useCompactLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              rating,
              const SizedBox(height: 4),
              date,
              if (runtimeLabel != null) ...[
                const SizedBox(height: 4),
                runtimeLabel,
              ],
            ],
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            rating,
            date,
            if (runtimeLabel != null) runtimeLabel,
          ],
        );
      },
    );
  }
}
