import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_result_dto.dart';

void main() {
  group('SearchResultDTO', () {
    final json = {
      'page': 1,
      'total_pages': 10,
      'results': [
        {
          'id': 1,
          'title': 'Movie 1',
          'poster_path': '/poster1.jpg',
          'vote_average': 7.5,
          'release_date': '2024-01-01',
          'overview': 'Overview 1',
        },
      ],
    };

    test('fromJson deserializes correctly', () {
      final dto = SearchResultDTO.fromJson(json);
      expect(dto.page, 1);
      expect(dto.totalPages, 10);
      expect(dto.results.length, 1);
      expect(dto.results.first, isA<MovieDTO>());
      expect(dto.results.first.id, 1);
      expect(dto.results.first.title, 'Movie 1');
    });

    test('toJson serializes correctly', () {
      final dto = SearchResultDTO.fromJson(json);
      final serialized = dto.toJson();
      expect(serialized['page'], 1);
      expect(serialized['total_pages'], 10);
      expect(serialized['results'], isA<List>());
    });

    test('handles empty results list', () {
      final emptyJson = {'page': 1, 'total_pages': 0, 'results': []};
      final dto = SearchResultDTO.fromJson(emptyJson);
      expect(dto.results, isEmpty);
      expect(dto.totalPages, 0);
    });
  });
}
