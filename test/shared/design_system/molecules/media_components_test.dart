import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/shared/design_system/molecules/media_card.dart';
import 'package:movie_universe_app/shared/design_system/molecules/media_card_layout.dart';
import 'package:movie_universe_app/shared/design_system/molecules/media_meta_row.dart';
import 'package:movie_universe_app/shared/design_system/models/media_display_model.dart';

void main() {
  group('MediaCard', () {
    testWidgets('renders movie badge in search layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 220,
              child: MediaCard(
                layout: MediaCardLayout.search,
                media: const MediaDisplayModel(
                  id: 1,
                  title: 'Inception',
                  posterPath: '/poster.jpg',
                  voteAverage: 8.8,
                  subtitle: '2010',
                  mediaType: MediaType.movie,
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Inception'), findsOneWidget);
      expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    });

    testWidgets('hides media type badge in section layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 220,
              child: MediaCard(
                media: const MediaDisplayModel(
                  id: 2,
                  title: 'Breaking Bad',
                  posterPath: '/tv.jpg',
                  voteAverage: 9.5,
                  subtitle: '2008',
                  mediaType: MediaType.tvShow,
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Breaking Bad'), findsOneWidget);
      expect(find.byIcon(Icons.tv_outlined), findsNothing);
    });

    testWidgets('renders TV badge in search layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 220,
              child: MediaCard(
                layout: MediaCardLayout.search,
                media: const MediaDisplayModel(
                  id: 2,
                  title: 'Breaking Bad',
                  posterPath: '/tv.jpg',
                  voteAverage: 9.5,
                  subtitle: '2008',
                  mediaType: MediaType.tvShow,
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Breaking Bad'), findsOneWidget);
      expect(find.byIcon(Icons.tv_outlined), findsOneWidget);
    });
  });

  group('MediaMetaRow', () {
    testWidgets('renders movie runtime metadata', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaMetaRow(
              rating: 8.5,
              dateLabel: '2024-01-01',
              runtimeMinutes: 120,
            ),
          ),
        ),
      );

      expect(find.text('2024-01-01'), findsOneWidget);
      expect(find.text('120 min'), findsOneWidget);
    });

    testWidgets('renders TV seasons and episodes metadata', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaMetaRow(
              rating: 9.0,
              dateLabel: '2008-01-20',
              numberOfSeasons: 5,
              numberOfEpisodes: 62,
            ),
          ),
        ),
      );

      expect(find.text('2008-01-20'), findsOneWidget);
      expect(find.text('5 seasons · 62 episodes'), findsOneWidget);
    });
  });
}
