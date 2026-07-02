import 'package:flutter/material.dart';

import '../../../features/movies/domain/entities/movie_detail_entity.dart';
import '../../../core/media/tmdb_image.dart';
import '../atoms/genre_chip.dart';
import '../atoms/poster_image.dart';
import '../molecules/movie_meta_row.dart';

class MovieDetailBody extends StatelessWidget {
  const MovieDetailBody({
    super.key,
    required this.details,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MovieDetailEntity details;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backdropUrl = imageUrls.backdrop(details.backdropPath);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (backdropUrl != null)
            Image.network(
              backdropUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 200,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosterImage(
                      path: details.posterPath,
                      width: 120,
                      height: 180,
                      size: TmdbPosterSize.large,
                      borderRadius: BorderRadius.circular(8),
                      placeholderIconSize: 48,
                      imageUrls: imageUrls,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          MovieMetaRow(
                            rating: details.voteAverage,
                            releaseDate: details.releaseDate,
                            runtime: details.runtime,
                            ratingIconSize: 18,
                            ratingTextStyle: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: details.genres
                      .map((genre) => GenreChip(label: genre.name))
                      .toList(),
                ),
                if (details.tagline.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    details.tagline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(details.overview, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
