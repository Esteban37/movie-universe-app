import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/molecules/movie_meta_row.dart';

void main() {
  testWidgets('MovieMetaRow renders rating, date, and runtime', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieMetaRow(
            rating: 7.5,
            releaseDate: '2024-01-01',
            runtime: 120,
          ),
        ),
      ),
    );

    expect(find.text('7.5'), findsOneWidget);
    expect(find.text('2024-01-01'), findsOneWidget);
    expect(find.text('120 min'), findsOneWidget);
  });
}
