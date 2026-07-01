import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';

void main() {
  group('MovieDTO', () {
    final json = {
      'id': 1,
      'title': 'Test Movie',
      'poster_path': '/poster.jpg',
      'vote_average': 7.5,
      'release_date': '2024-01-01',
      'overview': 'A test overview',
    };

    test('fromJson deserializes correctly', () {
      final dto = MovieDTO.fromJson(json);
      expect(dto.id, 1);
      expect(dto.title, 'Test Movie');
      expect(dto.posterPath, '/poster.jpg');
      expect(dto.voteAverage, 7.5);
      expect(dto.releaseDate, '2024-01-01');
      expect(dto.overview, 'A test overview');
    });

    test('toJson serializes correctly', () {
      final dto = MovieDTO.fromJson(json);
      final serialized = dto.toJson();
      expect(serialized['id'], 1);
      expect(serialized['title'], 'Test Movie');
      expect(serialized['poster_path'], '/poster.jpg');
      expect(serialized['vote_average'], 7.5);
    });

    test('handles null fields', () {
      final jsonWithNulls = {
        'id': 2,
        'title': 'No Poster',
        'poster_path': null,
        'vote_average': 0.0,
        'release_date': null,
        'overview': null,
      };
      final dto = MovieDTO.fromJson(jsonWithNulls);
      expect(dto.posterPath, isNull);
      expect(dto.releaseDate, isNull);
      expect(dto.overview, isNull);
    });
  });
}
