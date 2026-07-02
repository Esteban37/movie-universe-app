import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_multi_result_dto.dart';
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

  group('searchMedia', () {
    test('maps SearchMultiResultDTO to SearchResultEntity', () async {
      when(() => mockDataSource.searchMulti('test', page: 1)).thenAnswer(
        (_) async => const SearchMultiResultDTO(
          page: 1,
          totalPages: 5,
          results: [
            TmdbMultiSearchItemDto(
              mediaType: 'movie',
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

      final result = await repository.searchMedia('test');

      expect(result, isA<SearchResultEntity>());
      expect(result.page, 1);
      expect(result.totalPages, 5);
      expect(result.results.length, 1);
      expect(result.results.first, isA<MovieMediaItem>());
      expect(result.results.first.id, 1);
      expect(result.results.first.title, 'Test Movie');
    });

    test('filters out unsupported media types', () async {
      when(() => mockDataSource.searchMulti('test', page: 1)).thenAnswer(
        (_) async => const SearchMultiResultDTO(
          page: 1,
          totalPages: 1,
          results: [
            TmdbMultiSearchItemDto(
              mediaType: 'person',
              id: 99,
              title: 'Actor',
            ),
            TmdbMultiSearchItemDto(
              mediaType: 'tv',
              id: 2,
              name: 'Test Show',
              posterPath: '/tv.jpg',
              voteAverage: 8.0,
              firstAirDate: '2020-01-01',
              overview: 'TV overview',
            ),
          ],
        ),
      );

      final result = await repository.searchMedia('test');

      expect(result.results.length, 1);
      expect(result.results.first, isA<TvShowMediaItem>());
      expect(result.results.first.title, 'Test Show');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.searchMulti('test', page: 1)).thenThrow(
        DioException(
          message: 'Network error',
          requestOptions: RequestOptions(path: '/search/multi'),
        ),
      );

      expect(() => repository.searchMedia('test'), throwsA(isA<Failure>()));
    });

    test('passes page parameter to data source', () async {
      when(() => mockDataSource.searchMulti('test', page: 3)).thenAnswer(
        (_) async =>
            const SearchMultiResultDTO(page: 3, totalPages: 10, results: []),
      );

      await repository.searchMedia('test', page: 3);

      verify(() => mockDataSource.searchMulti('test', page: 3)).called(1);
    });
  });
}
