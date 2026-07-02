import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/screens/movie_detail_screen.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_details_provider.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/shared/widgets/hero_backdrop.dart';
import 'package:movie_universe_app/shared/widgets/skeleton_loader.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

const _testDetail = MovieDetailEntity(
  id: 1,
  title: 'Inception',
  posterPath: '/poster.jpg',
  voteAverage: 8.8,
  releaseDate: '2010-07-16',
  overview:
      'A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea into the mind of a C.E.O.',
  backdropPath: '/backdrop.jpg',
  genres: [
    Genre(id: 28, name: 'Action'),
    Genre(id: 878, name: 'Sci-Fi'),
  ],
  runtime: 148,
  tagline: 'Your mind is the scene of the crime.',
);

Widget createTestApp({
  required MovieRepository repository,
  required String movieId,
}) {
  return ProviderScope(
    overrides: [movieRepositoryProvider.overrideWith((ref) => repository)],
    child: MaterialApp(home: MovieDetailScreen(movieId: movieId)),
  );
}

void main() {
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
  });

  testWidgets('5.1 Shows skeleton on loading', (tester) async {
    when(() => mockRepository.getMovieDetails(1)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return _testDetail;
    });

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, movieId: '1'),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('5.2 Shows movie data when loaded', (tester) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, movieId: '1'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Inception'), findsWidgets);
  });

  testWidgets('5.3 Shows error with retry button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieDetailsProvider(1).overrideWithValue(
            AsyncValue.error(Exception('Failed to load'), StackTrace.current),
          ),
        ],
        child: const MaterialApp(home: MovieDetailScreen(movieId: '1')),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('5.6 Responsive layout uses phone and tablet header heights', (
    tester,
  ) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, movieId: '1'),
    );
    await tester.pump();
    await tester.pump();

    expect(tester.widget<HeroBackdrop>(find.byType(HeroBackdrop)).height, 300);

    tester.view.physicalSize = const Size(700, 1024);
    await tester.pumpWidget(
      createTestApp(repository: mockRepository, movieId: '1'),
    );
    await tester.pump();
    await tester.pump();

    expect(tester.widget<HeroBackdrop>(find.byType(HeroBackdrop)).height, 420);
  });

  testWidgets('5.7 Renders content with reduced motion', (tester) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: createTestApp(repository: mockRepository, movieId: '1'),
      ),
    );
    await tester.pump();
    await tester.pump();

    final overviewReveal = find.descendant(
      of: find.byKey(const ValueKey('detail-overview')),
      matching: find.byType(Opacity),
    );

    expect(find.text('Inception'), findsWidgets);
    expect(tester.widget<Opacity>(overviewReveal).opacity, 1);
  });

  testWidgets('5.4 Header collapse reveals app bar and staged content', (
    tester,
  ) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, movieId: '1'),
    );
    await tester.pump();
    await tester.pump();

    final appBarTitle = tester.widget<Text>(
      find.byKey(const ValueKey('collapsed-app-bar-title')),
    );
    expect(appBarTitle.style?.color?.a, 0);

    // Content is visible from first paint (no scroll-tied hiding).
    final overviewReveal = find
        .descendant(
          of: find.byKey(const ValueKey('detail-overview')),
          matching: find.byType(Opacity),
        )
        .first;
    expect(tester.widget<Opacity>(overviewReveal).opacity, greaterThan(0.9));

    // Collapsing the header reveals the floating app bar title.
    final listView = find.byType(CustomScrollView);
    await tester.drag(listView, const Offset(0, -1000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final collapsedTitle = tester.widget<Text>(
      find.byKey(const ValueKey('collapsed-app-bar-title')),
    );
    expect(collapsedTitle.style?.color?.a, greaterThan(0.9));
  });

  testWidgets('5.5 Dismiss gesture springs back below threshold', (
    tester,
  ) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    final pageBackKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
        child: MaterialApp(
          navigatorKey: pageBackKey,
          home: const MovieDetailScreen(movieId: '1'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.flingFrom(const Offset(200, 50), const Offset(0, 80), 100);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MovieDetailScreen), findsOneWidget);
  });

  testWidgets('5.5 Dismiss gesture above threshold pops route', (tester) async {
    when(
      () => mockRepository.getMovieDetails(1),
    ).thenAnswer((_) async => _testDetail);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MovieDetailScreen(movieId: '1'),
                    ),
                  );
                },
                child: const Text('Open detail'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 220));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailScreen), findsNothing);
    expect(find.text('Open detail'), findsOneWidget);
  });
}
