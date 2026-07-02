import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/atoms/section_title.dart';

void main() {
  testWidgets('SectionTitle renders the title text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionTitle(title: 'Overview')),
      ),
    );

    expect(find.text('Overview'), findsOneWidget);
  });
}
