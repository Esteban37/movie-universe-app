import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/atoms/rating_badge.dart';

void main() {
  testWidgets('RatingBadge uses theme tertiary color for star', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(tertiary: Colors.teal),
        ),
        home: const Scaffold(body: RatingBadge(rating: 8.5)),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(icon.color, Colors.teal);
    expect(find.text('8.5'), findsOneWidget);
  });
}
