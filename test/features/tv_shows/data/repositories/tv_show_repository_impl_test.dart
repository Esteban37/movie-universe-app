import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_tv_show_dto.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/tv_shows/data/datasources/tv_show_remote_datasource.dart';
import 'package:movie_universe_app/features/tv_shows/data/dtos/tv_show_detail_dto.dart';
import 'package:movie_universe_app/features/tv_shows/data/dtos/tv_show_response_dto.dart';
import 'package:movie_universe_app/features/tv_shows/data/repositories/tv_show_repository_impl.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

class MockTvShowRemoteDataSource extends Mock
    implements TvShowRemoteDataSource {}

void main() {
  late MockTvShowRemoteDataSource mockDataSource;
  late TvShowRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockTvShowRemoteDataSource();
    repository = TvShowRepositoryImpl(mockDataSource);
  });

  group('getPopular', () {
    test('maps TvShowResponseDTO to list of TvShowEntity', () async {
      when(() => mockDataSource.getPopular(page: 1)).thenAnswer(
        (_) async => const TvShowResponseDTO(
          page: 1,
          totalPages: 1,
          results: [
            TmdbTvShowDto(
              id: 1,
              name: 'Test Show',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              firstAirDate: '2024-01-01',
              overview: 'Overview',
            ),
          ],
        ),
      );

      final result = await repository.getPopular();

      expect(result, isA<List<TvShowEntity>>());
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.name, 'Test Show');
      expect(result.first.posterPath, '/poster.jpg');
      expect(result.first.voteAverage, 7.5);
      expect(result.first.firstAirDate, '2024-01-01');
      expect(result.first.overview, 'Overview');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getPopular(page: 1)).thenThrow(
        DioException(
          message: 'Network error',
          requestOptions: RequestOptions(path: '/tv/popular'),
        ),
      );

      expect(() => repository.getPopular(), throwsA(isA<Failure>()));
    });
  });

  group('getTopRated', () {
    test('maps TvShowResponseDTO to list of TvShowEntity', () async {
      when(() => mockDataSource.getTopRated(page: 1)).thenAnswer(
        (_) async => const TvShowResponseDTO(
          page: 1,
          totalPages: 1,
          results: [
            TmdbTvShowDto(
              id: 2,
              name: 'Top Rated Show',
              posterPath: '/poster2.jpg',
              voteAverage: 8.0,
              firstAirDate: '2024-02-01',
              overview: 'Great show',
            ),
          ],
        ),
      );

      final result = await repository.getTopRated();

      expect(result.length, 1);
      expect(result.first.name, 'Top Rated Show');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getTopRated(page: 1)).thenThrow(
        DioException(
          message: 'Timeout',
          requestOptions: RequestOptions(path: '/tv/top_rated'),
        ),
      );

      expect(() => repository.getTopRated(), throwsA(isA<Failure>()));
    });
  });

  group('getTvShowDetails', () {
    test('maps TvShowDetailDTO to TvShowDetailEntity', () async {
      when(() => mockDataSource.getTvShowDetails(1)).thenAnswer(
        (_) async => const TvShowDetailDTO(
          id: 1,
          name: 'Detail Show',
          posterPath: '/poster.jpg',
          voteAverage: 7.5,
          firstAirDate: '2024-01-01',
          overview: 'Overview',
          backdropPath: '/backdrop.jpg',
          genres: [TvGenreDTO(id: 18, name: 'Drama')],
          tagline: 'Tagline',
          numberOfSeasons: 3,
          numberOfEpisodes: 24,
          status: 'Returning Series',
          networks: [TvNetworkDTO(id: 1, name: 'HBO')],
        ),
      );

      final result = await repository.getTvShowDetails(1);

      expect(result, isA<TvShowDetailEntity>());
      expect(result.id, 1);
      expect(result.name, 'Detail Show');
      expect(result.backdropPath, '/backdrop.jpg');
      expect(result.numberOfSeasons, 3);
      expect(result.numberOfEpisodes, 24);
      expect(result.status, 'Returning Series');
      expect(result.networks, ['HBO']);
      expect(result.genres.first.name, 'Drama');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getTvShowDetails(1)).thenThrow(
        DioException(
          message: 'Not found',
          requestOptions: RequestOptions(path: '/tv/1'),
        ),
      );

      expect(() => repository.getTvShowDetails(1), throwsA(isA<Failure>()));
    });
  });
}
