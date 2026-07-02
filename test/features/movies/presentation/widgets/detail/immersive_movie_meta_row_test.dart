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

  testWidgets('ImmersiveMovieMetaRow does not overflow in narrow header space', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            child: ImmersiveMovieMetaRow(
              voteAverage: 8.8,
              releaseDate: '2010-07-16',
              runtime: 148,
              lightText: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('8.8'), findsOneWidget);
    expect(find.text('2010-07-16'), findsOneWidget);
    expect(find.text('148 min'), findsOneWidget);
  });
}
