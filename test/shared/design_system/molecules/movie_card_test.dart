import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/shared/design_system/molecules/movie_card.dart';

void main() {
  const movie = MovieEntity(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    releaseDate: '2010-07-16',
    overview: 'A dream within a dream.',
  );

  testWidgets('MovieCard renders title and rating', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: movie, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
  });
}
