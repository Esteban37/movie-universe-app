import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/shared/domain/entities/media_reference.dart';
import 'package:movie_universe_app/shared/domain/entities/media_type.dart';

void main() {
  group('MediaReference', () {
    test('equals by id and type', () {
      const a = MediaReference(id: 42, type: MediaType.movie);
      const b = MediaReference(id: 42, type: MediaType.movie);
      const c = MediaReference(id: 42, type: MediaType.tvShow);

      expect(a, b);
      expect(a, isNot(c));
    });

    test('is exposed from MediaItem', () {
      const item = MediaItem.movie(
        MovieEntity(
          id: 7,
          title: 'Test',
          posterPath: '/p.jpg',
          voteAverage: 7.0,
          releaseDate: '2020',
          overview: 'Overview',
        ),
      );

      expect(
        item.reference,
        const MediaReference(id: 7, type: MediaType.movie),
      );
    });
  });
}
