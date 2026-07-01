import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_response_dto.dart';

void main() {
  group('MovieResponseDTO', () {
    final json = {
      'page': 1,
      'total_pages': 500,
      'results': [
        {
          'id': 1,
          'title': 'Movie 1',
          'poster_path': '/poster1.jpg',
          'vote_average': 7.5,
          'release_date': '2024-01-01',
          'overview': 'Overview 1',
        },
        {
          'id': 2,
          'title': 'Movie 2',
          'poster_path': '/poster2.jpg',
          'vote_average': 8.0,
          'release_date': '2024-02-01',
          'overview': 'Overview 2',
        },
      ],
    };

    test('fromJson deserializes paginated response', () {
      final response = MovieResponseDTO.fromJson(json);
      expect(response.page, 1);
      expect(response.totalPages, 500);
      expect(response.results.length, 2);
      expect(response.results.first.title, 'Movie 1');
      expect(response.results.last.title, 'Movie 2');
    });

    test('toJson serializes correctly', () {
      final response = MovieResponseDTO.fromJson(json);
      final serialized = response.toJson();
      expect(serialized['page'], 1);
      expect(serialized['total_pages'], 500);
      expect((serialized['results'] as List).length, 2);
    });

    test('handles empty results', () {
      final emptyJson = {
        'page': 1,
        'total_pages': 0,
        'results': [],
      };
      final response = MovieResponseDTO.fromJson(emptyJson);
      expect(response.results, isEmpty);
    });
  });
}
