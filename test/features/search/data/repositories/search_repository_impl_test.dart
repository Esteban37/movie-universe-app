import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_result_dto.dart';
import 'package:movie_universe_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';

class MockSearchRemoteDataSource extends Mock
    implements SearchRemoteDataSource {}

void main() {
  late MockSearchRemoteDataSource mockDataSource;
  late SearchRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockSearchRemoteDataSource();
    repository = SearchRepositoryImpl(mockDataSource);
  });

  group('searchMovies', () {
    test('maps SearchResultDTO to SearchResultEntity', () async {
      when(() => mockDataSource.search('test', page: 1)).thenAnswer(
        (_) async => const SearchResultDTO(
          page: 1,
          totalPages: 5,
          results: [
            MovieDTO(
              id: 1,
              title: 'Test Movie',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              releaseDate: '2024-01-01',
              overview: 'Overview',
            ),
          ],
        ),
      );

      final result = await repository.searchMovies('test');

      expect(result, isA<SearchResultEntity>());
      expect(result.page, 1);
      expect(result.totalPages, 5);
      expect(result.results.length, 1);
      expect(result.results.first, isA<MovieEntity>());
      expect(result.results.first.id, 1);
      expect(result.results.first.title, 'Test Movie');
      expect(result.results.first.posterPath, '/poster.jpg');
      expect(result.results.first.voteAverage, 7.5);
      expect(result.results.first.releaseDate, '2024-01-01');
      expect(result.results.first.overview, 'Overview');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.search('test', page: 1)).thenThrow(
        DioException(
          message: 'Network error',
          requestOptions: RequestOptions(path: '/search/movie'),
        ),
      );

      expect(() => repository.searchMovies('test'), throwsA(isA<Failure>()));
    });

    test('handles empty results', () async {
      when(() => mockDataSource.search('empty', page: 1)).thenAnswer(
        (_) async => const SearchResultDTO(page: 1, totalPages: 0, results: []),
      );

      final result = await repository.searchMovies('empty');

      expect(result.results, isEmpty);
      expect(result.totalPages, 0);
    });

    test('passes page parameter to data source', () async {
      when(() => mockDataSource.search('test', page: 3)).thenAnswer(
        (_) async =>
            const SearchResultDTO(page: 3, totalPages: 10, results: []),
      );

      await repository.searchMovies('test', page: 3);

      verify(() => mockDataSource.search('test', page: 3)).called(1);
    });
  });
}
