import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/media/tmdb_image.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/detail/detail_header_delegate.dart';
import 'package:movie_universe_app/shared/widgets/hero_backdrop.dart';

void main() {
  testWidgets('DetailHeaderDelegate renders hero backdrop and title', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DetailHeaderDelegate(
                  backdropUrl: 'https://example.com/backdrop.jpg',
                  posterPath: '/poster.jpg',
                  imageUrls: const TmdbImageUrl(),
                  title: 'Inception',
                  voteAverage: 8.8,
                  releaseDate: '2010-07-16',
                  runtime: 148,
                  headerHeight: 300,
                  collapseProgress: 0,
                  reducedMotion: true,
                  isTablet: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(HeroBackdrop), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
    expect(find.byKey(const ValueKey('header-poster')), findsOneWidget);
  });
}
