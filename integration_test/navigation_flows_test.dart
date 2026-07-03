import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_universe_app/features/movies/presentation/screens/movie_detail_screen.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/movie_card.dart';
import 'package:movie_universe_app/features/search/presentation/screens/search_screen.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_media_card.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/screens/tv_show_detail_screen.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/widgets/tv_show_card.dart';

import 'helpers/navigation_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Shell navigation flows', () {
    testWidgets('Movies tab: list to detail', (tester) async {
      await pumpNavigationApp(tester);

      expect(find.byType(MovieDetailScreen), findsNothing);
      await tester.tap(find.byType(MovieCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieDetailScreen), findsOneWidget);
      expect(find.text('Inception'), findsWidgets);
    });

    testWidgets('Series tab: list to detail', (tester) async {
      await pumpNavigationApp(tester);
      await selectShellTab(tester, 'Series');

      expect(find.byType(TvShowDetailScreen), findsNothing);
      await tester.tap(find.byType(TvShowCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(TvShowDetailScreen), findsOneWidget);
      expect(find.text('Breaking Bad'), findsWidgets);
    });

    testWidgets('Search tab: query to detail', (tester) async {
      await pumpNavigationApp(tester);
      await selectShellTab(tester, 'Search');

      expect(find.byType(SearchScreen), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'batman');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.byType(SearchMediaCard), findsWidgets);
      await tester.tap(find.byType(SearchMediaCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieDetailScreen), findsOneWidget);
      expect(find.text('The Dark Knight'), findsWidgets);
    });
  });
}
