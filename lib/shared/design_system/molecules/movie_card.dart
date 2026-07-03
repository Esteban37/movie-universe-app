import 'package:flutter/material.dart';

import '../../../core/media/tmdb_image.dart';
import '../models/media_display_model.dart';
import 'media_card.dart';
import 'media_card_layout.dart';

/// Movie list card for dedicated movie sections (Popular, Top Rated).
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.media,
    required this.onTap,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MediaDisplayModel media;
  final VoidCallback onTap;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    return MediaCard(
      media: media,
      onTap: onTap,
      imageUrls: imageUrls,
      layout: MediaCardLayout.section,
    );
  }
}
