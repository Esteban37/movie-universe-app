import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/screens/tv_show_detail_screen.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/screens/tv_show_list_screen.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/widgets/tv_show_card.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

const _popularShows = [
  TvShowEntity(
    id: 1,
    name: 'Breaking Bad',
    posterPath: '/poster.jpg',
    voteAverage: 9.5,
    firstAirDate: '2008-01-20',
    overview: 'A chemistry teacher turned meth producer.',
  ),
];

const _tvShowDetail = TvShowDetailEntity(
  id: 1,
  name: 'Breaking Bad',
  posterPath: '/poster.jpg',
  voteAverage: 9.5,
  firstAirDate: '2008-01-20',
  overview: 'A chemistry teacher turned meth producer.',
  backdropPath: '/backdrop.jpg',
  genres: [TvGenre(id: 18, name: 'Drama')],
  tagline: 'All bad things...',
  numberOfSeasons: 5,
  numberOfEpisodes: 62,
  status: 'Ended',
  networks: ['AMC'],
);

void main() {
  late MockTvShowRepository mockRepository;

  setUpAll(() {
    AppRouter.defineRoutes();
  });

  setUp(() {
    mockRepository = MockTvShowRepository();
    when(
      () => mockRepository.getPopular(page: any(named: 'page')),
    ).thenAnswer((_) async => _popularShows);
    when(
      () => mockRepository.getTopRated(page: any(named: 'page')),
    ).thenAnswer((_) async => const <TvShowEntity>[]);
    when(
      () => mockRepository.getTvShowDetails(1),
    ).thenAnswer((_) async => _tvShowDetail);
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        tvShowRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
      child: MaterialApp(
        onGenerateRoute: FluroRouter.appRouter.generator,
        home: const TvShowListScreen(),
      ),
    );
  }

  testWidgets('renders Popular and Top Rated tabs with TV show cards', (
    tester,
  ) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(TvShowCard), findsWidgets);
  });

  testWidgets('tapping a TV show card navigates from the list to the detail', (
    tester,
  ) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.byType(TvShowListScreen), findsOneWidget);
    expect(find.byType(TvShowDetailScreen), findsNothing);

    await tester.tap(find.byType(TvShowCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(TvShowDetailScreen), findsOneWidget);
    verify(() => mockRepository.getTvShowDetails(1)).called(1);
  });

  testWidgets(
    'shows friendly message when popular TV shows fail with typed Failure',
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
      (index) => TvShowEntity(
        id: index + 1,
        name: 'Show ${index + 1}',
        posterPath: '/poster$index.jpg',
        voteAverage: 7.0,
        firstAirDate: '2024-01-01',
        overview: 'Overview ${index + 1}',
      ),
    );
    const page2Show = TvShowEntity(
      id: 21,
      name: 'Show 21',
      posterPath: '/poster21.jpg',
      voteAverage: 8.0,
      firstAirDate: '2024-02-01',
      overview: 'Overview 21',
    );

    when(
      () => mockRepository.getPopular(page: 1),
    ).thenAnswer((_) async => page1);
    when(
      () => mockRepository.getPopular(page: 2),
    ).thenAnswer((_) async => [page2Show]);

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
