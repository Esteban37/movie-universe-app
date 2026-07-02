import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/media/tmdb_image.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/detail/detail_content.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/detail/immersive_detail_constants.dart';
import 'package:movie_universe_app/shared/design_system/atoms/genre_chip.dart';

void main() {
  const details = MovieDetailEntity(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    releaseDate: '2010-07-16',
    overview: 'Dream within a dream.',
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 28, name: 'Action')],
    runtime: 148,
    tagline: 'Your mind is the scene of the crime.',
  );

  testWidgets('DetailContent renders overview and tagline', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DetailContent(
            details: details,
            posterPath: details.posterPath,
            imageUrls: const TmdbImageUrl(),
            collapseProgress: 0,
            isTablet: false,
          ),
        ),
      ),
    );

    expect(find.text('Dream within a dream.'), findsOneWidget);
    expect(find.text('Your mind is the scene of the crime.'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(GenreChip), findsOneWidget);
  });

  testWidgets('DetailContent shows compact poster row when collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DetailContent(
            details: details,
            posterPath: details.posterPath,
            imageUrls: const TmdbImageUrl(),
            collapseProgress:
                ImmersiveDetailConstants.contentPosterFadeStart + 0.1,
            isTablet: false,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('content-poster')), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);
  });
}
