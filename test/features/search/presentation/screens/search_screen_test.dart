import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';
import 'package:movie_universe_app/features/search/presentation/screens/search_screen.dart';

class MockSearchMedia extends Mock implements SearchMedia {}

void main() {
  late MockSearchMedia mockSearchMedia;

  setUp(() {
    mockSearchMedia = MockSearchMedia();
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        searchMediaProvider.overrideWith((ref) => mockSearchMedia),
      ],
      child: const MaterialApp(home: SearchScreen()),
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
}
