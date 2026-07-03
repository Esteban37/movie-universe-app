import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/atoms/genre_chip.dart';
import '../../../../../shared/design_system/atoms/poster_image.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../../../../shared/presentation/detail/immersive_detail_constants.dart';
import 'immersive_movie_meta_row.dart';
import 'staggered_reveal.dart';

class DetailContent extends StatelessWidget {
  const DetailContent({
    super.key,
    required this.details,
    required this.posterPath,
    required this.imageUrls,
    required this.collapseProgress,
    required this.isTablet,
  });

  final MovieDetailEntity details;
  final String posterPath;
  final TmdbImageUrl imageUrls;
  final double collapseProgress;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final topPadding = isTablet ? 24.0 : 16.0;
    final compactInfoOpacity =
        ((collapseProgress - ImmersiveDetailConstants.contentPosterFadeStart) /
                ImmersiveDetailConstants.contentPosterFadeSpan)
            .clamp(0.0, 1.0);
    final overviewStyle = theme.textTheme.bodyLarge?.copyWith(height: 1.6);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compactInfoOpacity > 0) ...[
              Opacity(
                key: const ValueKey('detail-info-row'),
                opacity: compactInfoOpacity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Poster for ${details.title}',
                      image: true,
                      child: PosterImage(
                        key: const ValueKey('content-poster'),
                        path: posterPath,
                        width: ImmersiveDetailConstants.contentPosterWidth,
                        height: ImmersiveDetailConstants.contentPosterHeight,
                        size: TmdbPosterSize.large,
                        borderRadius: BorderRadius.circular(4),
                        placeholderIconSize: 24,
                        imageUrls: imageUrls,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style: isTablet
                                ? theme.textTheme.headlineSmall
                                : theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ImmersiveMovieMetaRow(
                            voteAverage: details.voteAverage,
                            releaseDate: details.releaseDate,
                            runtime: details.runtime,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            StaggeredReveal(
              key: const ValueKey('detail-genre-chips'),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: details.genres
                    .map(
                      (genre) => GenreChip(
                        label: genre.name,
                        labelStyle: theme.textTheme.labelSmall,
                      ),
                    )
                    .toList(),
              ),
            ),
            StaggeredReveal(
              key: const ValueKey('detail-overview'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (details.tagline.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      details.tagline,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(details.overview, style: overviewStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
