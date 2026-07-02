import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_tv_show_dto.dart';
import 'package:movie_universe_app/core/data/mappers/tmdb_tv_show_mapper.dart';

void main() {
  group('TmdbTvShowMapper', () {
    test('toEntity maps all fields', () {
      const dto = TmdbTvShowDto(
        id: 1399,
        name: 'Game of Thrones',
        posterPath: '/poster.jpg',
        voteAverage: 8.4,
        firstAirDate: '2011-04-17',
        overview: 'Nine noble families fight for control.',
      );

      final entity = TmdbTvShowMapper.toEntity(dto);

      expect(entity.id, 1399);
      expect(entity.name, 'Game of Thrones');
      expect(entity.posterPath, '/poster.jpg');
      expect(entity.voteAverage, 8.4);
      expect(entity.firstAirDate, '2011-04-17');
      expect(entity.overview, 'Nine noble families fight for control.');
    });

    test('toEntity defaults null fields to empty strings', () {
      const dto = TmdbTvShowDto(
        id: 2,
        name: 'No Poster',
        posterPath: null,
        voteAverage: 0.0,
        firstAirDate: null,
        overview: null,
      );

      final entity = TmdbTvShowMapper.toEntity(dto);

      expect(entity.posterPath, '');
      expect(entity.firstAirDate, '');
      expect(entity.overview, '');
    });

    test('toEntityList maps each dto', () {
      const dtos = [
        TmdbTvShowDto(
          id: 1,
          name: 'Show A',
          posterPath: '/a.jpg',
          voteAverage: 7.0,
          firstAirDate: '2020-01-01',
          overview: 'A',
        ),
        TmdbTvShowDto(
          id: 2,
          name: 'Show B',
          posterPath: '/b.jpg',
          voteAverage: 8.0,
          firstAirDate: '2021-01-01',
          overview: 'B',
        ),
      ];

      final entities = TmdbTvShowMapper.toEntityList(dtos);

      expect(entities, hasLength(2));
      expect(entities.first.name, 'Show A');
      expect(entities.last.name, 'Show B');
    });
  });
}
