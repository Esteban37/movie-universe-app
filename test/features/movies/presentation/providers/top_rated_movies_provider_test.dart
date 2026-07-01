import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/top_rated_movies_provider.dart';
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

  group('TopRatedMoviesProvider', () {
    test('loads first page on initialization', () async {
      when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
        (_) async => [
          MovieEntity(
            id: 1,
            title: 'Movie 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );

      final container = createContainer();

      final result = await container.read(topRatedMoviesProvider.future);

      expect(result.length, 1);
      expect(result.first.title, 'Movie 1');
      verify(() => mockRepository.getTopRated(page: 1)).called(1);
    });

    test('loadNextPage appends movies and updates state', () async {
      const page1Movies = [
        MovieEntity(
          id: 1,
          title: 'Movie 1',
          posterPath: '/poster1.jpg',
          voteAverage: 7.5,
          releaseDate: '2024-01-01',
          overview: 'Overview 1',
        ),
      ];
      const page2Movies = [
        MovieEntity(
          id: 2,
          title: 'Movie 2',
          posterPath: '/poster2.jpg',
          voteAverage: 8.0,
          releaseDate: '2024-02-01',
          overview: 'Overview 2',
        ),
      ];

      when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
        (_) async => page1Movies,
      );
      when(() => mockRepository.getTopRated(page: 2)).thenAnswer(
        (_) async => page2Movies,
      );

      final container = createContainer();

      await container.read(topRatedMoviesProvider.future);

      await container.read(topRatedMoviesProvider.notifier).loadNextPage();

      final state = container.read(topRatedMoviesProvider);
      expect(state.value, [page1Movies[0], page2Movies[0]]);

      verify(() => mockRepository.getTopRated(page: 1)).called(1);
      verify(() => mockRepository.getTopRated(page: 2)).called(1);
    });

    test('prevents duplicate page loads', () async {
      when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
        (_) async => [
          MovieEntity(
            id: 1,
            title: 'Movie 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );
      when(() => mockRepository.getTopRated(page: 2)).thenAnswer(
        (_) async => [
          MovieEntity(
            id: 2,
            title: 'Movie 2',
            posterPath: '/poster2.jpg',
            voteAverage: 8.0,
            releaseDate: '2024-02-01',
            overview: 'Overview 2',
          ),
        ],
      );

      final container = createContainer();

      await container.read(topRatedMoviesProvider.future);

      final notifier = container.read(topRatedMoviesProvider.notifier);

      await Future.wait([
        notifier.loadNextPage(),
        notifier.loadNextPage(),
        notifier.loadNextPage(),
      ]);

      verify(() => mockRepository.getTopRated(page: 2)).called(1);
    });

    test('loadNextPage handles empty response as end of list', () async {
      when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
        (_) async => [
          MovieEntity(
            id: 1,
            title: 'Movie 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );
      when(() => mockRepository.getTopRated(page: 2)).thenAnswer(
        (_) async => [],
      );

      final container = createContainer();

      await container.read(topRatedMoviesProvider.future);

      final notifier = container.read(topRatedMoviesProvider.notifier);

      await notifier.loadNextPage();

      final state = container.read(topRatedMoviesProvider);
      expect(state.value?.length, 1);

      await notifier.loadNextPage();

      verify(() => mockRepository.getTopRated(page: 2)).called(1);
    });
  });
}
