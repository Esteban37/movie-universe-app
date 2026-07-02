import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

void main() {
  group('SearchResultEntity', () {
    const emptyResult = SearchResultEntity(page: 0, totalPages: 0, results: []);

    const resultWithMovies = SearchResultEntity(
      page: 1,
      totalPages: 5,
      results: [
        MovieEntity(
          id: 1,
          title: 'Test Movie',
          posterPath: '/poster.jpg',
          voteAverage: 7.5,
          releaseDate: '2024-01-01',
          overview: 'A test overview',
        ),
      ],
    );

    test('can be created with required fields', () {
      expect(resultWithMovies.page, 1);
      expect(resultWithMovies.totalPages, 5);
      expect(resultWithMovies.results.length, 1);
      expect(resultWithMovies.results.first.title, 'Test Movie');
    });

    test('supports empty results', () {
      expect(emptyResult.results, isEmpty);
    });

    test('supports copyWith', () {
      const modified = SearchResultEntity(page: 1, totalPages: 5, results: []);
      final updated = modified.copyWith(page: 2);
      expect(updated.page, 2);
      expect(updated.totalPages, 5);
    });

    test('props are correct for equality', () {
      const sameResult = SearchResultEntity(
        page: 1,
        totalPages: 5,
        results: [
          MovieEntity(
            id: 1,
            title: 'Test Movie',
            posterPath: '/poster.jpg',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            overview: 'A test overview',
          ),
        ],
      );
      expect(resultWithMovies, sameResult);
    });
  });
}
