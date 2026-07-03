import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/atoms/empty_view.dart';

void main() {
  testWidgets('EmptyView renders the provided message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: EmptyView(message: 'Nothing here')),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
  });
}
