import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.movie});

  final MovieEntity movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            'https://image.tmdb.org/t/p/w92${movie.posterPath}',
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
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(movie.voteAverage.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
        onTap: () {
          FluroRouter.appRouter.navigateTo(
            context,
            '/movie/${movie.id}',
            transition: TransitionType.fadeIn,
          );
        },
      ),
    );
  }
}
