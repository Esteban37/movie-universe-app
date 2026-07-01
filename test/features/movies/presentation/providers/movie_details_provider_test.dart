import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_details_provider.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        movieRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  }

  group('MovieDetailsProvider', () {
    test('fetches movie details by ID', () async {
      const movieDetail = MovieDetailEntity(
        id: 1,
        title: 'Test Movie',
        posterPath: '/poster.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
        overview: 'A great movie.',
        backdropPath: '/backdrop.jpg',
        genres: [],
        runtime: 120,
        tagline: 'Amazing!',
      );

      when(() => mockRepository.getMovieDetails(1)).thenAnswer(
        (_) async => movieDetail,
      );

      final container = createContainer();

      final result = await container.read(movieDetailsProvider(1).future);

      expect(result, movieDetail);
      verify(() => mockRepository.getMovieDetails(1)).called(1);
    });

    test('handles errors', () async {
      when(() => mockRepository.getMovieDetails(1)).thenThrow(
        Exception('Network error'),
      );

      final container = createContainer();

      container.read(movieDetailsProvider(1));
      await Future(() {});

      final state = container.read(movieDetailsProvider(1));
      expect(state.hasError, true);

      verify(() => mockRepository.getMovieDetails(1)).called(1);
    });

    test('caches results per movie ID', () async {
      const movie1 = MovieDetailEntity(
        id: 1,
        title: 'Movie 1',
        posterPath: '/poster1.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
        overview: 'Overview 1',
        backdropPath: null,
        genres: [],
        runtime: 0,
        tagline: '',
      );
      const movie2 = MovieDetailEntity(
        id: 2,
        title: 'Movie 2',
        posterPath: '/poster2.jpg',
        voteAverage: 8.0,
        releaseDate: '2024-02-01',
        overview: 'Overview 2',
        backdropPath: null,
        genres: [],
        runtime: 0,
        tagline: '',
      );

      when(() => mockRepository.getMovieDetails(1)).thenAnswer(
        (_) async => movie1,
      );
      when(() => mockRepository.getMovieDetails(2)).thenAnswer(
        (_) async => movie2,
      );

      final container = createContainer();

      await container.read(movieDetailsProvider(1).future);
      await container.read(movieDetailsProvider(2).future);

      expect(
        container.read(movieDetailsProvider(1)).value,
        movie1,
      );
      expect(
        container.read(movieDetailsProvider(2)).value,
        movie2,
      );

      verify(() => mockRepository.getMovieDetails(1)).called(1);
      verify(() => mockRepository.getMovieDetails(2)).called(1);
    });
  });
}
