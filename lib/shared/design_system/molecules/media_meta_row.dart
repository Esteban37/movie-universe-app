import 'package:flutter/material.dart';

import '../atoms/rating_badge.dart';

class MediaMetaRow extends StatelessWidget {
  const MediaMetaRow({
    super.key,
    required this.rating,
    required this.dateLabel,
    this.runtimeMinutes,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.ratingIconSize = 18,
    this.ratingTextStyle,
    this.dateTextStyle,
    this.detailTextStyle,
  });

  final double rating;
  final String dateLabel;
  final int? runtimeMinutes;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final double ratingIconSize;
  final TextStyle? ratingTextStyle;
  final TextStyle? dateTextStyle;
  final TextStyle? detailTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBadge(
          rating: rating,
          iconSize: ratingIconSize,
          textStyle: ratingTextStyle ?? theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Text(dateLabel, style: dateTextStyle ?? theme.textTheme.bodyMedium),
        if (runtimeMinutes != null && runtimeMinutes! > 0) ...[
          const SizedBox(height: 4),
          Text(
            '$runtimeMinutes min',
            style: detailTextStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
        if (numberOfSeasons != null && numberOfSeasons! > 0) ...[
          const SizedBox(height: 4),
          Text(
            _seasonsEpisodesLabel(numberOfSeasons!, numberOfEpisodes ?? 0),
            style: detailTextStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  String _seasonsEpisodesLabel(int seasons, int episodes) {
    final seasonsLabel = seasons == 1 ? '1 season' : '$seasons seasons';
    if (episodes <= 0) return seasonsLabel;
    final episodesLabel = episodes == 1 ? '1 episode' : '$episodes episodes';
    return '$seasonsLabel · $episodesLabel';
  }
}
