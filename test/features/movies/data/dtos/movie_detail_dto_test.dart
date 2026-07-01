import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';

void main() {
  group('MovieDetailDTO', () {
    final json = {
      'id': 1,
      'title': 'Test Movie',
      'poster_path': '/poster.jpg',
      'vote_average': 7.5,
      'release_date': '2024-01-01',
      'overview': 'A test overview',
      'backdrop_path': '/backdrop.jpg',
      'genres': [
        {'id': 28, 'name': 'Action'},
        {'id': 12, 'name': 'Adventure'},
      ],
      'runtime': 120,
      'tagline': 'A great tagline',
    };

    test('fromJson deserializes correctly', () {
      final dto = MovieDetailDTO.fromJson(json);
      expect(dto.id, 1);
      expect(dto.title, 'Test Movie');
      expect(dto.backdropPath, '/backdrop.jpg');
      expect(dto.genres.length, 2);
      expect(dto.genres.first.id, 28);
      expect(dto.genres.first.name, 'Action');
      expect(dto.runtime, 120);
      expect(dto.tagline, 'A great tagline');
    });

    test('toJson serializes correctly', () {
      final dto = MovieDetailDTO.fromJson(json);
      final serialized = dto.toJson();
      expect(serialized['id'], 1);
      expect(serialized['backdrop_path'], '/backdrop.jpg');
      expect(serialized['runtime'], 120);
    });

    test('handles null backdropPath', () {
      final jsonNoBackdrop = Map<String, dynamic>.from(json)
        ..remove('backdrop_path');
      final dto = MovieDetailDTO.fromJson(jsonNoBackdrop);
      expect(dto.backdropPath, isNull);
    });
  });

  group('GenreDTO', () {
    test('fromJson deserializes correctly', () {
      final json = {'id': 28, 'name': 'Action'};
      final genre = GenreDTO.fromJson(json);
      expect(genre.id, 28);
      expect(genre.name, 'Action');
    });

    test('toJson serializes correctly', () {
      final json = {'id': 28, 'name': 'Action'};
      final genre = GenreDTO.fromJson(json);
      final serialized = genre.toJson();
      expect(serialized['id'], 28);
      expect(serialized['name'], 'Action');
    });
  });
}
