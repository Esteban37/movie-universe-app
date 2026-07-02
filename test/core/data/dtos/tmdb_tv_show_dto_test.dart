import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_tv_show_dto.dart';

void main() {
  group('TmdbTvShowDto', () {
    final json = {
      'id': 1399,
      'name': 'Game of Thrones',
      'poster_path': '/poster.jpg',
      'vote_average': 8.4,
      'first_air_date': '2011-04-17',
      'overview': 'Nine noble families fight for control.',
    };

    test('fromJson deserializes correctly', () {
      final dto = TmdbTvShowDto.fromJson(json);
      expect(dto.id, 1399);
      expect(dto.name, 'Game of Thrones');
      expect(dto.posterPath, '/poster.jpg');
      expect(dto.voteAverage, 8.4);
      expect(dto.firstAirDate, '2011-04-17');
      expect(dto.overview, 'Nine noble families fight for control.');
    });

    test('toJson serializes correctly', () {
      final dto = TmdbTvShowDto.fromJson(json);
      final serialized = dto.toJson();
      expect(serialized['id'], 1399);
      expect(serialized['name'], 'Game of Thrones');
      expect(serialized['poster_path'], '/poster.jpg');
      expect(serialized['vote_average'], 8.4);
    });

    test('handles null fields', () {
      final jsonWithNulls = {
        'id': 2,
        'name': 'No Poster',
        'poster_path': null,
        'vote_average': 0.0,
        'first_air_date': null,
        'overview': null,
      };
      final dto = TmdbTvShowDto.fromJson(jsonWithNulls);
      expect(dto.posterPath, isNull);
      expect(dto.firstAirDate, isNull);
      expect(dto.overview, isNull);
    });
  });
}
