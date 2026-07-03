import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

void main() {
  group('MovieEntity', () {
    const movie = MovieEntity(
      id: 1,
      title: 'Test Movie',
      posterPath: '/poster.jpg',
      voteAverage: 7.5,
      releaseDate: '2024-01-01',
      overview: 'A test movie overview',
    );

    test('can be created with required fields', () {
      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.posterPath, '/poster.jpg');
      expect(movie.voteAverage, 7.5);
      expect(movie.releaseDate, '2024-01-01');
      expect(movie.overview, 'A test movie overview');
    });

    test('supports copyWith', () {
      final modified = movie.copyWith(title: 'Modified Title');
      expect(modified.title, 'Modified Title');
      expect(modified.id, 1);
    });

    test('props are correct for equality', () {
      const sameMovie = MovieEntity(
        id: 1,
        title: 'Test Movie',
        posterPath: '/poster.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
        overview: 'A test movie overview',
      );
      expect(movie, sameMovie);
    });
  });

  group('MovieDetailEntity', () {
    const detail = MovieDetailEntity(
      id: 1,
      title: 'Test Movie',
      posterPath: '/poster.jpg',
      voteAverage: 7.5,
      releaseDate: '2024-01-01',
      overview: 'A test movie overview',
      backdropPath: '/backdrop.jpg',
      genres: [Genre(id: 28, name: 'Action')],
      runtime: 120,
      tagline: 'A test tagline',
    );

    test('can be created with all fields', () {
      expect(detail.id, 1);
      expect(detail.title, 'Test Movie');
      expect(detail.backdropPath, '/backdrop.jpg');
      expect(detail.genres.length, 1);
      expect(detail.genres.first.id, 28);
      expect(detail.genres.first.name, 'Action');
      expect(detail.runtime, 120);
      expect(detail.tagline, 'A test tagline');
    });

    test('supports copyWith', () {
      final modified = detail.copyWith(tagline: 'New tagline');
      expect(modified.tagline, 'New tagline');
    });
  });
}
