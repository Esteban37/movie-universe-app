import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/media/tmdb_image.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/detail/floating_detail_app_bar.dart';

void main() {
  testWidgets('FloatingDetailAppBar renders back button and title', (
    tester,
  ) async {
    var backPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDetailAppBar(
                backdropPath: '/backdrop.jpg',
                imageUrls: const TmdbImageUrl(),
                title: 'Inception',
                collapseProgress: 0,
                onBack: () => backPressed = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Inception'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    expect(backPressed, isTrue);
  });

  testWidgets('FloatingDetailAppBar reveals title color when collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDetailAppBar(
                backdropPath: '/backdrop.jpg',
                imageUrls: const TmdbImageUrl(),
                title: 'Inception',
                collapseProgress: 1,
                onBack: () {},
              ),
            ],
          ),
        ),
      ),
    );

    final title = tester.widget<Text>(
      find.byKey(const ValueKey('collapsed-app-bar-title')),
    );
    expect(title.style?.color?.a, greaterThan(0.9));
  });
}
