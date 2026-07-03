import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/atoms/poster_image.dart';

void main() {
  testWidgets('PosterImage shows placeholder when path is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PosterImage(path: '', width: 100, height: 150)),
      ),
    );

    expect(find.byIcon(Icons.movie), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
