import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/widgets/detail/immersive_tv_show_meta_row.dart';

void main() {
  testWidgets('ImmersiveTvShowMetaRow renders rating, date and seasons', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImmersiveTvShowMetaRow(
            voteAverage: 8.8,
            firstAirDate: '2010-07-16',
            numberOfSeasons: 5,
            numberOfEpisodes: 62,
          ),
        ),
      ),
    );

    expect(find.text('8.8'), findsOneWidget);
    expect(find.text('2010-07-16'), findsOneWidget);
    expect(find.text('5 seasons · 62 eps'), findsOneWidget);
  });

  testWidgets('ImmersiveTvShowMetaRow does not overflow in narrow header space', (
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
            child: ImmersiveTvShowMetaRow(
              voteAverage: 8.8,
              firstAirDate: '2010-07-16',
              numberOfSeasons: 5,
              numberOfEpisodes: 62,
              lightText: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('8.8'), findsOneWidget);
    expect(find.text('2010-07-16'), findsOneWidget);
    expect(find.text('5 seasons · 62 eps'), findsOneWidget);
  });
}
