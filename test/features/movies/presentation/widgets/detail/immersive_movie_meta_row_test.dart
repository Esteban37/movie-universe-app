import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/presentation/widgets/detail/immersive_movie_meta_row.dart';

void main() {
  testWidgets('ImmersiveMovieMetaRow renders rating, year and runtime', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImmersiveMovieMetaRow(
            voteAverage: 8.8,
            releaseDate: '2010-07-16',
            runtime: 148,
          ),
        ),
      ),
    );

    expect(find.text('8.8'), findsOneWidget);
    expect(find.text('2010-07-16'), findsOneWidget);
    expect(find.text('148 min'), findsOneWidget);
  });
}
