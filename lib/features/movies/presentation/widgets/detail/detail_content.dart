import 'package:flutter/material.dart';

import '../../../domain/entities/movie_detail_entity.dart';
import 'immersive_detail_constants.dart';
import 'immersive_movie_meta_row.dart';
import 'staggered_reveal.dart';

class DetailContent extends StatelessWidget {
  const DetailContent({
    super.key,
    required this.details,
    required this.posterUrl,
    required this.collapseProgress,
    required this.isTablet,
  });

  final MovieDetailEntity details;
  final String posterUrl;
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
    final overviewStyle =
        (isTablet ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge)
            ?.copyWith(height: 1.6);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: 'Poster for ${details.title}',
                      image: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          posterUrl,
                          key: const ValueKey('content-poster'),
                          width: ImmersiveDetailConstants.contentPosterWidth,
                          height: ImmersiveDetailConstants.contentPosterHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: ImmersiveDetailConstants.contentPosterWidth,
                            height:
                                ImmersiveDetailConstants.contentPosterHeight,
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.movie,
                              size: 24,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style:
                                (isTablet
                                        ? theme.textTheme.headlineSmall
                                        : theme.textTheme.titleLarge)
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                      (genre) => Chip(
                        label: Text(
                          genre.name,
                          style: theme.textTheme.labelSmall,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
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
