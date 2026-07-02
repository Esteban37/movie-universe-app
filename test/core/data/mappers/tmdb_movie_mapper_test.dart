import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_movie_dto.dart';
import 'package:movie_universe_app/core/data/mappers/tmdb_movie_mapper.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

void main() {
  group('TmdbMovieMapper', () {
    test('maps dto to entity with defaults for null fields', () {
      const dto = TmdbMovieDto(
        id: 1,
        title: 'Test',
        posterPath: null,
        voteAverage: 7.5,
        releaseDate: null,
        overview: null,
      );

      final entity = TmdbMovieMapper.toEntity(dto);

      expect(entity, isA<MovieEntity>());
      expect(entity.posterPath, '');
      expect(entity.releaseDate, '');
      expect(entity.overview, '');
    });

    test('maps list of dtos', () {
      const dtos = [
        TmdbMovieDto(
          id: 1,
          title: 'A',
          posterPath: '/a.jpg',
          voteAverage: 7.0,
          releaseDate: '2024-01-01',
          overview: 'A',
        ),
        TmdbMovieDto(
          id: 2,
          title: 'B',
          posterPath: '/b.jpg',
          voteAverage: 8.0,
          releaseDate: '2024-02-01',
          overview: 'B',
        ),
      ];

      final entities = TmdbMovieMapper.toEntityList(dtos);

      expect(entities.length, 2);
      expect(entities.first.title, 'A');
      expect(entities.last.title, 'B');
    });
  });
}
