import 'package:flutter/material.dart';

import '../../../core/media/tmdb_image.dart';
import '../atoms/poster_image.dart';
import '../atoms/rating_badge.dart';
import '../models/movie_display_model.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MovieDisplayModel movie;
  final VoidCallback onTap;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return PosterImage(
                    path: movie.posterPath,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    imageUrls: imageUrls,
                  );
                },
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
