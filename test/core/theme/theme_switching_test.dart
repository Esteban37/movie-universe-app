import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/main.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'TMDB_ACCESS_TOKEN=test-token');
  });

  tearDown(() {
    dotenv.clean();
  });

  testWidgets('App renders with dark theme by default', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MovieUniverseApp()));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });

  testWidgets('Both themes are provided', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MovieUniverseApp()));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
  });

  testWidgets('App renders without error with both themes', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MovieUniverseApp()));
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });
}
