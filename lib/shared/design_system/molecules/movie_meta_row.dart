import 'package:flutter/material.dart';

import '../atoms/rating_badge.dart';

class MovieMetaRow extends StatelessWidget {
  const MovieMetaRow({
    super.key,
    required this.rating,
    required this.releaseDate,
    this.runtime,
    this.ratingIconSize = 18,
    this.ratingTextStyle,
    this.dateTextStyle,
    this.runtimeTextStyle,
  });

  final double rating;
  final String releaseDate;
  final int? runtime;
  final double ratingIconSize;
  final TextStyle? ratingTextStyle;
  final TextStyle? dateTextStyle;
  final TextStyle? runtimeTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBadge(
          rating: rating,
          iconSize: ratingIconSize,
          textStyle: ratingTextStyle ?? theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(releaseDate, style: dateTextStyle ?? theme.textTheme.bodyMedium),
        if (runtime != null && runtime! > 0) ...[
          const SizedBox(height: 4),
          Text(
            '$runtime min',
            style: runtimeTextStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
