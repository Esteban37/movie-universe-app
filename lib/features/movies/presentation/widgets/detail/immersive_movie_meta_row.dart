import 'package:flutter/material.dart';

/// Horizontal meta row tuned for the immersive detail header and compact row.
class ImmersiveMovieMetaRow extends StatelessWidget {
  const ImmersiveMovieMetaRow({
    super.key,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    this.lightText = false,
  });

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

    return Row(
      children: [
        Semantics(
          label: 'Rating ${voteAverage.toStringAsFixed(1)} out of 10',
          child: Row(
            children: [
              Icon(Icons.star, size: 18, color: colorScheme.tertiary),
              const SizedBox(width: 4),
              Text(
                voteAverage.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: lightText ? colorScheme.onPrimary : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          releaseDate,
          style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor),
        ),
        if (runtime > 0) ...[
          const SizedBox(width: 8),
          Text(
            '$runtime min',
            style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor),
          ),
        ],
      ],
    );
  }
}
