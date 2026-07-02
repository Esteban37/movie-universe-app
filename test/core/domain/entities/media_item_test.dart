import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

void main() {
  group('MediaItem', () {
    const movie = MovieEntity(
      id: 1,
      title: 'Inception',
      posterPath: '/poster.jpg',
      voteAverage: 8.8,
      releaseDate: '2010-07-16',
      overview: 'A dream within a dream.',
    );

    const tvShow = TvShowEntity(
      id: 2,
      name: 'Breaking Bad',
      posterPath: '/tv.jpg',
      voteAverage: 9.5,
      firstAirDate: '2008-01-20',
      overview: 'A chemistry teacher turns to crime.',
    );

    test('movie variant exposes unified accessors', () {
      const item = MediaItem.movie(movie);

      expect(item.mediaType, MediaType.movie);
      expect(item.id, 1);
      expect(item.title, 'Inception');
      expect(item.posterPath, '/poster.jpg');
      expect(item.voteAverage, 8.8);
      expect(item.subtitle, '2010-07-16');
      expect(item.overview, 'A dream within a dream.');
    });

    test('tvShow variant exposes unified accessors', () {
      const item = MediaItem.tvShow(tvShow);

      expect(item.mediaType, MediaType.tvShow);
      expect(item.id, 2);
      expect(item.title, 'Breaking Bad');
      expect(item.posterPath, '/tv.jpg');
      expect(item.voteAverage, 9.5);
      expect(item.subtitle, '2008-01-20');
      expect(item.overview, 'A chemistry teacher turns to crime.');
    });

    test('switch is exhaustive over variants', () {
      const items = [MediaItem.movie(movie), MediaItem.tvShow(tvShow)];

      final labels = items.map((item) {
        return switch (item) {
          MovieMediaItem(:final movie) => 'movie:${movie.title}',
          TvShowMediaItem(:final tvShow) => 'tv:${tvShow.name}',
        };
      }).toList();

      expect(labels, ['movie:Inception', 'tv:Breaking Bad']);
    });
  });
}
