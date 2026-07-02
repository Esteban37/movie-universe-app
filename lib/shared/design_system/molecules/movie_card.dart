import 'package:flutter/material.dart';

import '../../../features/movies/domain/entities/movie_entity.dart';
import '../../../core/media/tmdb_image.dart';
import '../atoms/rating_badge.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MovieEntity movie;
  final VoidCallback onTap;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    final posterUrl = imageUrls.poster(
      movie.posterPath,
      size: TmdbPosterSize.medium,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: posterUrl == null
                  ? const Center(child: Icon(Icons.movie, size: 48))
                  : Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Center(child: Icon(Icons.movie, size: 48)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RatingBadge(rating: movie.voteAverage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
