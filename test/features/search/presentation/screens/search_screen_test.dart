import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_movies.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';
import 'package:movie_universe_app/features/search/presentation/screens/search_screen.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
  });

  Widget createApp() {
    return ProviderScope(
      overrides: [
        searchRepositoryProvider.overrideWith((ref) => mockSearchMovies),
      ],
      child: const MaterialApp(home: SearchScreen()),
    );
  }

  testWidgets('shows friendly failure message when search fails', (
    tester,
  ) async {
    when(
      () => mockSearchMovies.call('batman', page: 1),
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

  testWidgets('retry triggers a new search after failure', (tester) async {
    when(
      () => mockSearchMovies.call('batman', page: 1),
    ).thenThrow(NetworkFailure());

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    when(() => mockSearchMovies.call('batman', page: 1)).thenAnswer(
      (_) async =>
          const SearchResultEntity(page: 1, totalPages: 1, results: []),
    );

    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    verify(() => mockSearchMovies.call('batman', page: 1)).called(2);
  });
}
