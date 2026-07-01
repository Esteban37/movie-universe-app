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

  testWidgets('MovieUniverseApp renders movie list screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MovieUniverseApp()));
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });
}
