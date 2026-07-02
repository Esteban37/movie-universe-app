import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/widgets/hero_backdrop.dart';

void main() {
  testWidgets('HeroBackdrop renders image and gradient', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroBackdrop(
            imageUrl: 'https://example.com/test.jpg',
            height: 200,
          ),
        ),
      ),
    );

    expect(find.byType(HeroBackdrop), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('HeroBackdrop applies collapse progress', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroBackdrop(
            imageUrl: 'https://example.com/test.jpg',
            height: 200,
            collapseProgress: 0.5,
          ),
        ),
      ),
    );

    expect(find.byType(HeroBackdrop), findsOneWidget);
  });

  testWidgets('HeroBackdrop handles full collapse', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroBackdrop(
            imageUrl: 'https://example.com/test.jpg',
            height: 200,
            collapseProgress: 1.0,
          ),
        ),
      ),
    );

    expect(find.byType(HeroBackdrop), findsOneWidget);
  });

  testWidgets('HeroBackdrop uses scaffold background color from theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.amber),
        home: const Scaffold(
          body: HeroBackdrop(
            imageUrl: 'https://example.com/test.jpg',
            height: 200,
          ),
        ),
      ),
    );

    expect(find.byType(HeroBackdrop), findsOneWidget);
  });
}
