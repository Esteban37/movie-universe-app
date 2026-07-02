import 'package:flutter/material.dart';

/// Horizontal meta row tuned for the immersive TV detail header.
///
/// Stacks vertically when horizontal space is tight (e.g. phone header beside
/// the poster) and flows horizontally with [Wrap] on wider layouts.
class ImmersiveTvShowMetaRow extends StatelessWidget {
  const ImmersiveTvShowMetaRow({
    super.key,
    required this.voteAverage,
    required this.firstAirDate,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    this.lightText = false,
  });

  static const _compactLayoutMaxWidth = 240.0;

  final double voteAverage;
  final String firstAirDate;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final bool lightText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedColor = lightText
        ? colorScheme.onPrimary.withValues(alpha: 0.85)
        : colorScheme.onSurfaceVariant;

    final seasonsLabel =
        numberOfSeasons == 1 ? '1 season' : '$numberOfSeasons seasons';
    final episodesLabel =
        numberOfEpisodes == 1 ? '1 ep' : '$numberOfEpisodes eps';

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
      firstAirDate,
      style: metaStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final seasonsEpisodes = numberOfSeasons > 0
        ? Text(
            '$seasonsLabel · $episodesLabel',
            style: metaStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null;

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
              if (seasonsEpisodes != null) ...[
                const SizedBox(height: 4),
                seasonsEpisodes,
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
            if (seasonsEpisodes != null) seasonsEpisodes,
          ],
        );
      },
    );
  }
}
