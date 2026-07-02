import 'package:flutter/material.dart';

import 'media_meta_row.dart';

/// Backward-compatible movie-only meta row. Prefer [MediaMetaRow] for new code.
@Deprecated('Use MediaMetaRow instead')
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
    return MediaMetaRow(
      rating: rating,
      dateLabel: releaseDate,
      runtimeMinutes: runtime,
      ratingIconSize: ratingIconSize,
      ratingTextStyle: ratingTextStyle,
      dateTextStyle: dateTextStyle,
      detailTextStyle: runtimeTextStyle,
    );
  }
}
