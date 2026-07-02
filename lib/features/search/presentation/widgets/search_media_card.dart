import 'package:flutter/material.dart';

import '../../../../core/media/tmdb_image.dart';
import '../../../../shared/design_system/molecules/media_card.dart';
import '../../../../shared/design_system/molecules/media_card_layout.dart';
import '../../../../shared/design_system/models/media_display_model.dart';

/// Search result card for mixed movie and TV show results.
class SearchMediaCard extends StatelessWidget {
  const SearchMediaCard({
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
      layout: MediaCardLayout.search,
    );
  }
}
