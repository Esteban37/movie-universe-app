import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/design_system/models/movie_display_model.dart';
import 'package:movie_universe_app/shared/design_system/molecules/search_result_card.dart';

void main() {
  const movie = MovieDisplayModel(
    id: 42,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    releaseDate: '2010-07-16',
  );

  testWidgets('SearchResultCard renders title, date and rating', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SearchResultCard(movie: movie))),
    );

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('2010-07-16'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
  });
}
