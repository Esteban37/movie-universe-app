import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/atoms/genre_chip.dart';
import '../../../../../shared/design_system/atoms/poster_image.dart';
import '../../../../../shared/design_system/atoms/status_chip.dart';
import '../../../../../shared/presentation/detail/immersive_detail_constants.dart';
import '../../../domain/entities/tv_show_detail_entity.dart';
import 'immersive_tv_show_meta_row.dart';

class TvDetailContent extends StatelessWidget {
  const TvDetailContent({
    super.key,
    required this.details,
    required this.posterPath,
    required this.imageUrls,
    required this.collapseProgress,
    required this.isTablet,
  });

  final TvShowDetailEntity details;
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
                key: const ValueKey('tv-detail-info-row'),
                opacity: compactInfoOpacity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Poster for ${details.name}',
                      image: true,
                      child: PosterImage(
                        key: const ValueKey('tv-content-poster'),
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
                            details.name,
                            style: isTablet
                                ? theme.textTheme.headlineSmall
                                : theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ImmersiveTvShowMetaRow(
                            voteAverage: details.voteAverage,
                            firstAirDate: details.firstAirDate,
                            numberOfSeasons: details.numberOfSeasons,
                            numberOfEpisodes: details.numberOfEpisodes,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (details.status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StatusChip(label: details.status),
              ),
            Wrap(
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
            if (details.networks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                details.networks.join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
    );
  }
}
