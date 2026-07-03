import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';
import 'package:movie_universe_app/features/search/presentation/screens/search_screen.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_media_card.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/screens/tv_show_detail_screen.dart';

class MockSearchMedia extends Mock implements SearchMedia {}

class MockTvShowRepository extends Mock implements TvShowRepository {}

const _tvShowDetail = TvShowDetailEntity(
  id: 2,
  name: 'The Wire',
  posterPath: '/wire.jpg',
  voteAverage: 9.3,
  firstAirDate: '2002-06-02',
  overview: 'Baltimore drug scene.',
  backdropPath: '/backdrop.jpg',
  genres: [TvGenre(id: 18, name: 'Crime')],
  tagline: 'Listen carefully',
  numberOfSeasons: 5,
  numberOfEpisodes: 60,
  status: 'Ended',
  networks: ['HBO'],
);

void main() {
  late MockSearchMedia mockSearchMedia;
  late MockTvShowRepository mockTvShowRepository;

  setUpAll(() {
    AppRouter.defineRoutes();
  });

  setUp(() {
    mockSearchMedia = MockSearchMedia();
    mockTvShowRepository = MockTvShowRepository();
    when(
      () => mockTvShowRepository.getTvShowDetails(any()),
    ).thenAnswer((_) async => _tvShowDetail);
  });

  Widget createApp({bool enableNavigation = false}) {
    return ProviderScope(
      overrides: [
        searchMediaProvider.overrideWith((ref) => mockSearchMedia),
        tvShowRepositoryProvider.overrideWith((ref) => mockTvShowRepository),
      ],
      child: MaterialApp(
        onGenerateRoute: enableNavigation
            ? FluroRouter.appRouter.generator
            : null,
        home: const SearchScreen(),
      ),
    );
  }

  testWidgets('shows friendly failure message when search fails', (
    tester,
  ) async {
    when(
      () => mockSearchMedia.call('batman', page: 1),
    ).thenThrow(NetworkFailure());

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(
      find.text('No internet connection. Please check your network.'),
      findsOneWidget,
    );
    expect(find.textContaining('Instance of'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows filter chips for All, Movies, and Series', (tester) async {
    when(() => mockSearchMedia.call(any(), page: any(named: 'page'))).thenAnswer(
      (_) async => const SearchResultEntity(page: 1, totalPages: 1, results: []),
    );

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Series'), findsOneWidget);
  });

  testWidgets('retry triggers a new search after failure', (tester) async {
    when(
      () => mockSearchMedia.call('batman', page: 1),
    ).thenThrow(NetworkFailure());

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    when(() => mockSearchMedia.call('batman', page: 1)).thenAnswer(
      (_) async =>
          const SearchResultEntity(page: 1, totalPages: 1, results: []),
    );

    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    verify(() => mockSearchMedia.call('batman', page: 1)).called(2);
  });

  testWidgets('renders search results in a grid without layout errors', (
    tester,
  ) async {
    when(() => mockSearchMedia.call('batman', page: 1)).thenAnswer(
      (_) async => SearchResultEntity(
        page: 1,
        totalPages: 1,
        results: [
          MediaItem.movie(
            const MovieEntity(
              id: 1,
              title: 'Batman Begins',
              posterPath: '/batman.jpg',
              voteAverage: 8.2,
              releaseDate: '2005-06-15',
              overview: 'Origin story',
            ),
          ),
        ],
      ),
    );

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Batman Begins'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('scrolling near the bottom loads the next search page', (
    tester,
  ) async {
    final page1Results = List.generate(
      20,
      (index) => MediaItem.movie(
        MovieEntity(
          id: index + 1,
          title: 'Result ${index + 1}',
          posterPath: '/poster$index.jpg',
          voteAverage: 7.0,
          releaseDate: '2024-01-01',
          overview: 'Overview ${index + 1}',
        ),
      ),
    );

    when(() => mockSearchMedia.call('batman', page: 1)).thenAnswer(
      (_) async => SearchResultEntity(
        page: 1,
        totalPages: 2,
        results: page1Results,
      ),
    );
    when(() => mockSearchMedia.call('batman', page: 2)).thenAnswer(
      (_) async => SearchResultEntity(
        page: 2,
        totalPages: 2,
        results: [
          MediaItem.movie(
            const MovieEntity(
              id: 21,
              title: 'Result 21',
              posterPath: '/poster21.jpg',
              voteAverage: 8.0,
              releaseDate: '2024-02-01',
              overview: 'Overview 21',
            ),
          ),
        ],
      ),
    );

    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(GridView), const Offset(0, -5000));
    await tester.pumpAndSettle();

    verify(() => mockSearchMedia.call('batman', page: 1)).called(1);
    verify(() => mockSearchMedia.call('batman', page: 2)).called(1);
  });

  testWidgets('tapping a TV search result navigates to TV show detail', (
    tester,
  ) async {
    when(() => mockSearchMedia.call('wire', page: 1)).thenAnswer(
      (_) async => SearchResultEntity(
        page: 1,
        totalPages: 1,
        results: [
          MediaItem.tvShow(
            const TvShowEntity(
              id: 2,
              name: 'The Wire',
              posterPath: '/wire.jpg',
              voteAverage: 9.3,
              firstAirDate: '2002-06-02',
              overview: 'Baltimore drug scene.',
            ),
          ),
        ],
      ),
    );

    await tester.pumpWidget(createApp(enableNavigation: true));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'wire');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.byType(TvShowDetailScreen), findsNothing);

    await tester.tap(find.byType(SearchMediaCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(TvShowDetailScreen), findsOneWidget);
    verify(() => mockTvShowRepository.getTvShowDetails(2)).called(1);
  });
}
