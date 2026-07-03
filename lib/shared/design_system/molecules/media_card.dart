import 'package:flutter/material.dart';

import '../../../shared/domain/entities/media_type.dart';
import '../../../core/media/tmdb_image.dart';
import '../atoms/poster_image.dart';
import '../atoms/rating_badge.dart';
import '../models/media_display_model.dart';
import 'media_card_layout.dart';

/// Canonical poster card for movies and TV shows.
///
/// Feature screens should prefer dedicated wrappers ([MovieCard], [TvShowCard],
/// search cards) so layout intent stays explicit at the call site.
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.media,
    required this.onTap,
    TmdbImageUrl? imageUrls,
    this.layout = MediaCardLayout.section,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MediaDisplayModel media;
  final VoidCallback onTap;
  final TmdbImageUrl imageUrls;
  final MediaCardLayout layout;

  bool get _showsMediaTypeBadge => layout == MediaCardLayout.search;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return PosterImage(
                        path: media.posterPath,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        imageUrls: imageUrls,
                      );
                    },
                  ),
                  if (_showsMediaTypeBadge)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Icon(
                            media.mediaType == MediaType.movie
                                ? Icons.movie_outlined
                                : Icons.tv_outlined,
                            size: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  RatingBadge(rating: media.voteAverage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
