import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_result_dto.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SearchRemoteDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = SearchRemoteDataSource(mockDio);
  });

  group('search', () {
    test('calls /search/movie with query and page parameters', () async {
      when(() => mockDio.get(
            '/search/movie',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: {
            'page': 1,
            'total_pages': 5,
            'results': [
              {
                'id': 1,
                'title': 'Test',
                'poster_path': null,
                'vote_average': 0.0,
                'release_date': null,
                'overview': null,
              },
            ],
          },
          requestOptions: RequestOptions(path: '/search/movie'),
          statusCode: 200,
        ),
      );

      final result = await dataSource.search('test', page: 1);

      expect(result, isA<SearchResultDTO>());
      expect(result.page, 1);
      expect(result.results.length, 1);
      verify(() => mockDio.get(
            '/search/movie',
            queryParameters: {'query': 'test', 'page': 1},
          )).called(1);
    });

    test('handles empty results', () async {
      when(() => mockDio.get(
            '/search/movie',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: {
            'page': 1,
            'total_pages': 0,
            'results': [],
          },
          requestOptions: RequestOptions(path: '/search/movie'),
          statusCode: 200,
        ),
      );

      final result = await dataSource.search('empty', page: 1);

      expect(result.results, isEmpty);
      expect(result.totalPages, 0);
    });
  });
}
