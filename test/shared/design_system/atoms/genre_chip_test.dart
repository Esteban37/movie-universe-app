import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/atoms/genre_chip.dart';

void main() {
  testWidgets('GenreChip renders the genre label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: GenreChip(label: 'Action')),
      ),
    );

    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(Chip), findsOneWidget);
  });
}
