import 'package:flutter/material.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import '../../../features/movies/domain/entities/movie_entity.dart';
import '../../../core/media/tmdb_image.dart';
import '../atoms/rating_badge.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.movie});

  final MovieEntity movie;

  @override
  Widget build(BuildContext context) {
    final posterUrl = TmdbImageUrl.poster(
      movie.posterPath,
      size: TmdbPosterSize.small,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: posterUrl == null
              ? const Icon(Icons.movie, size: 46)
              : Image.network(
                  posterUrl,
                  width: 46,
                  height: 69,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.movie, size: 46),
                ),
        ),
        title: Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.releaseDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            RatingBadge(rating: movie.voteAverage, iconSize: 14),
          ],
        ),
        onTap: () {
          AppRouter.pushMovieDetail(context, '${movie.id}');
        },
      ),
    );
  }
}
