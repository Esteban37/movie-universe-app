import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/features/movies/presentation/screens/movie_detail_screen.dart';
import 'package:movie_universe_app/features/movies/presentation/screens/movie_list_screen.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/movie_card.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

const _popularMovies = [
  MovieEntity(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    releaseDate: '2010-07-16',
    overview: 'A thief who steals corporate secrets.',
  ),
];

const _movieDetail = MovieDetailEntity(
  id: 1,
  title: 'Inception',
  posterPath: '/poster.jpg',
  voteAverage: 8.8,
  releaseDate: '2010-07-16',
  overview: 'A thief who steals corporate secrets.',
  backdropPath: '/backdrop.jpg',
  genres: [Genre(id: 28, name: 'Action')],
  runtime: 148,
  tagline: 'Your mind is the scene of the crime.',
);

void main() {
  late MockMovieRepository mockRepository;

  setUpAll(() {
    // Registers the Fluro handlers ('/movie/:id', etc.) used by navigation.
    AppRouter.defineRoutes();
  });

  setUp(() {
    mockRepository = MockMovieRepository();
    when(
      () => mockRepository.getPopular(page: any(named: 'page')),
    ).thenAnswer((_) async => _popularMovies);
    when(
      () => mockRepository.getTopRated(page: any(named: 'page')),
    ).thenAnswer((_) async => const <MovieEntity>[]);
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _movieDetail);
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
      child: MaterialApp(
        onGenerateRoute: FluroRouter.appRouter.generator,
        home: const MovieListScreen(),
      ),
    );
  }

  testWidgets('renders Popular and Top Rated tabs with movie cards', (
    tester,
  ) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(MovieCard), findsWidgets);
  });

  testWidgets('tapping a movie card navigates from the list to the detail', (
    tester,
  ) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    // Starts on the list, detail not yet present.
    expect(find.byType(MovieListScreen), findsOneWidget);
    expect(find.byType(MovieDetailScreen), findsNothing);

    await tester.tap(find.byType(MovieCard).first);
    await tester.pumpAndSettle();

    // The detail route was pushed for the tapped movie.
    expect(find.byType(MovieDetailScreen), findsOneWidget);
    verify(() => mockRepository.getMovieDetails(1)).called(1);
  });

  testWidgets(
    'shows friendly message when popular movies fail with typed Failure',
    (tester) async {
      when(
        () => mockRepository.getPopular(page: any(named: 'page')),
      ).thenThrow(NetworkFailure());

      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(
        find.text('No internet connection. Please check your network.'),
        findsOneWidget,
      );
      expect(find.textContaining('Instance of'), findsNothing);
    },
  );

  testWidgets('scrolling near the bottom loads the next page', (tester) async {
    final page1 = List.generate(
      20,
      (index) => MovieEntity(
        id: index + 1,
        title: 'Movie ${index + 1}',
        posterPath: '/poster$index.jpg',
        voteAverage: 7.0,
        releaseDate: '2024-01-01',
        overview: 'Overview ${index + 1}',
      ),
    );
    const page2Movie = MovieEntity(
      id: 21,
      title: 'Movie 21',
      posterPath: '/poster21.jpg',
      voteAverage: 8.0,
      releaseDate: '2024-02-01',
      overview: 'Overview 21',
    );

    when(
      () => mockRepository.getPopular(page: 1),
    ).thenAnswer((_) async => page1);
    when(
      () => mockRepository.getPopular(page: 2),
    ).thenAnswer((_) async => [page2Movie]);

    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(GridView), const Offset(0, -5000));
    await tester.pumpAndSettle();

    verify(() => mockRepository.getPopular(page: 1)).called(1);
    verify(() => mockRepository.getPopular(page: 2)).called(1);
  });
}
