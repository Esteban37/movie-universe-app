import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_response_dto.dart';
import 'package:movie_universe_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

void main() {
  late MockMovieRemoteDataSource mockDataSource;
  late MovieRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(mockDataSource);
  });

  group('getPopular', () {
    test('maps MovieResponseDTO to list of MovieEntity', () async {
      when(() => mockDataSource.getPopular(page: 1)).thenAnswer(
        (_) async => MovieResponseDTO(
          page: 1,
          totalPages: 1,
          results: [
            MovieDTO(
              id: 1,
              title: 'Test',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              releaseDate: '2024-01-01',
              overview: 'Overview',
            ),
          ],
        ),
      );

      final result = await repository.getPopular();

      expect(result, isA<List<MovieEntity>>());
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.title, 'Test');
      expect(result.first.posterPath, '/poster.jpg');
      expect(result.first.voteAverage, 7.5);
      expect(result.first.releaseDate, '2024-01-01');
      expect(result.first.overview, 'Overview');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getPopular(page: 1)).thenThrow(
        DioException(
          message: 'Network error',
          requestOptions: RequestOptions(path: '/movie/popular'),
        ),
      );

      expect(
        () => repository.getPopular(),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('getTopRated', () {
    test('maps MovieResponseDTO to list of MovieEntity', () async {
      when(() => mockDataSource.getTopRated(page: 1)).thenAnswer(
        (_) async => MovieResponseDTO(
          page: 1,
          totalPages: 1,
          results: [
            MovieDTO(
              id: 2,
              title: 'Top Rated',
              posterPath: '/poster2.jpg',
              voteAverage: 8.0,
              releaseDate: '2024-02-01',
              overview: 'Great movie',
            ),
          ],
        ),
      );

      final result = await repository.getTopRated();

      expect(result.length, 1);
      expect(result.first.title, 'Top Rated');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getTopRated(page: 1)).thenThrow(
        DioException(
          message: 'Timeout',
          requestOptions: RequestOptions(path: '/movie/top_rated'),
        ),
      );

      expect(
        () => repository.getTopRated(),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('getMovieDetails', () {
    test('maps MovieDetailDTO to MovieDetailEntity', () async {
      when(() => mockDataSource.getMovieDetails(1)).thenAnswer(
        (_) async => MovieDetailDTO(
          id: 1,
          title: 'Detail Movie',
          posterPath: '/poster.jpg',
          voteAverage: 7.5,
          releaseDate: '2024-01-01',
          overview: 'Overview',
          backdropPath: '/backdrop.jpg',
          genres: [],
          runtime: 120,
          tagline: 'Tagline',
        ),
      );

      final result = await repository.getMovieDetails(1);

      expect(result, isA<MovieDetailEntity>());
      expect(result.id, 1);
      expect(result.title, 'Detail Movie');
      expect(result.backdropPath, '/backdrop.jpg');
      expect(result.runtime, 120);
      expect(result.tagline, 'Tagline');
    });

    test('throws Failure on DioException', () async {
      when(() => mockDataSource.getMovieDetails(1)).thenThrow(
        DioException(
          message: 'Not found',
          requestOptions: RequestOptions(path: '/movie/1'),
        ),
      );

      expect(
        () => repository.getMovieDetails(1),
        throwsA(isA<Failure>()),
      );
    });
  });
}
