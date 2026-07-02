import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/shared/design_system/models/media_display_model.dart';
import 'package:movie_universe_app/shared/design_system/molecules/movie_card.dart';

void main() {
  const media = MediaDisplayModel(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    subtitle: '2010-07-16',
    mediaType: MediaType.movie,
  );

  testWidgets('MovieCard renders title and rating without media badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: MovieCard(media: media, onTap: () {}),
          ),
        ),
      ),
    );

    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('8.8'), findsOneWidget);
    expect(find.byIcon(Icons.movie_outlined), findsNothing);
  });
}
