import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_media_card.dart';
import 'package:movie_universe_app/shared/design_system/models/media_display_model.dart';

void main() {
  testWidgets('SearchMediaCard renders media type badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 220,
            child: SearchMediaCard(
              media: const MediaDisplayModel(
                id: 1,
                title: 'Batman Begins',
                posterPath: '/batman.jpg',
                voteAverage: 8.2,
                subtitle: '2005',
                mediaType: MediaType.movie,
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Batman Begins'), findsOneWidget);
    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
  });
}
