import 'package:flutter/material.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import '../../../core/media/tmdb_image.dart';
import '../atoms/poster_image.dart';
import '../atoms/rating_badge.dart';
import '../models/movie_display_model.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.movie,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final MovieDisplayModel movie;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: PosterImage(
          path: movie.posterPath,
          width: 46,
          height: 69,
          size: TmdbPosterSize.small,
          borderRadius: BorderRadius.circular(4),
          placeholderIconSize: 46,
          imageUrls: imageUrls,
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
