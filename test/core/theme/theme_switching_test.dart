import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/main.dart';

import '../../helpers/offline_app_overrides.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'TMDB_ACCESS_TOKEN=test-token');
  });

  tearDown(() {
    dotenv.clean();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: offlineRepositoryOverrides(),
        child: const MovieUniverseApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('App renders with dark theme by default', (tester) async {
    await pumpApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });

  testWidgets('Both themes are provided', (tester) async {
    await pumpApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
  });

  testWidgets('App renders without error with both themes', (tester) async {
    await pumpApp(tester);

    expect(find.text('Movies'), findsAtLeastNWidgets(1));
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('Series'), findsOneWidget);
  });
}
