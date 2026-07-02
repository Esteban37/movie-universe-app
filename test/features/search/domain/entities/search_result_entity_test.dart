import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';

void main() {
  group('SearchResultEntity', () {
    test('holds paginated MediaItem results', () {
      const entity = SearchResultEntity(
        page: 2,
        totalPages: 10,
        results: [
          MediaItem.movie(
            MovieEntity(
              id: 1,
              title: 'Test Movie',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              releaseDate: '2024-01-01',
              overview: 'Overview',
            ),
          ),
        ],
      );

      expect(entity.page, 2);
      expect(entity.totalPages, 10);
      expect(entity.results.length, 1);
      expect(entity.results.first.title, 'Test Movie');
    });

    test('supports empty results', () {
      const entity = SearchResultEntity(
        page: 1,
        totalPages: 0,
        results: [],
      );

      expect(entity.results, isEmpty);
    });
  });
}
