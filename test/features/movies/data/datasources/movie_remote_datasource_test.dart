import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_response_dto.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MovieRemoteDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = MovieRemoteDataSource(mockDio);
  });

  group('getPopular', () {
    test('calls /movie/popular with page parameter', () async {
      when(
        () => mockDio.get(
          '/movie/popular',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'page': 1, 'total_pages': 500, 'results': []},
          requestOptions: RequestOptions(path: '/movie/popular'),
          statusCode: 200,
        ),
      );

      final result = await dataSource.getPopular(page: 1);

      expect(result, isA<MovieResponseDTO>());
      expect(result.page, 1);
      verify(
        () => mockDio.get('/movie/popular', queryParameters: {'page': 1}),
      ).called(1);
    });
  });

  group('getTopRated', () {
    test('calls /movie/top_rated with page parameter', () async {
      when(
        () => mockDio.get(
          '/movie/top_rated',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'page': 1, 'total_pages': 200, 'results': []},
          requestOptions: RequestOptions(path: '/movie/top_rated'),
          statusCode: 200,
        ),
      );

      final result = await dataSource.getTopRated(page: 1);

      expect(result, isA<MovieResponseDTO>());
      verify(
        () => mockDio.get('/movie/top_rated', queryParameters: {'page': 1}),
      ).called(1);
    });
  });

  group('getMovieDetails', () {
    test('calls /movie/{id} endpoint', () async {
      when(() => mockDio.get('/movie/123')).thenAnswer(
        (_) async => Response(
          data: {
            'id': 123,
            'title': 'Test',
            'poster_path': null,
            'vote_average': 0.0,
            'release_date': null,
            'overview': null,
            'backdrop_path': null,
            'genres': [],
            'runtime': 0,
            'tagline': '',
          },
          requestOptions: RequestOptions(path: '/movie/123'),
          statusCode: 200,
        ),
      );

      final result = await dataSource.getMovieDetails(123);

      expect(result, isA<MovieDetailDTO>());
      expect(result.id, 123);
      verify(() => mockDio.get('/movie/123')).called(1);
    });
  });
}
