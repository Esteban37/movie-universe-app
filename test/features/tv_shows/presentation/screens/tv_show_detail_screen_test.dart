import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_details_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/screens/tv_show_detail_screen.dart';
import 'package:movie_universe_app/shared/widgets/skeleton_loader.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

const _testDetail = TvShowDetailEntity(
  id: 1,
  name: 'Breaking Bad',
  posterPath: '/poster.jpg',
  voteAverage: 9.5,
  firstAirDate: '2008-01-20',
  overview: 'A chemistry teacher turned meth producer.',
  backdropPath: '/backdrop.jpg',
  genres: [TvGenre(id: 18, name: 'Drama')],
  tagline: 'All bad things...',
  numberOfSeasons: 5,
  numberOfEpisodes: 62,
  status: 'Ended',
  networks: ['AMC'],
);

Widget createTestApp({
  required TvShowRepository repository,
  required String tvShowId,
}) {
  return ProviderScope(
    overrides: [tvShowRepositoryProvider.overrideWith((ref) => repository)],
    child: MaterialApp(home: TvShowDetailScreen(tvShowId: tvShowId)),
  );
}

void main() {
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
  });

  testWidgets('shows skeleton on loading', (tester) async {
    when(() => mockRepository.getTvShowDetails(1)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return _testDetail;
    });

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, tvShowId: '1'),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('shows TV show data when loaded', (tester) async {
    when(
      () => mockRepository.getTvShowDetails(1),
    ).thenAnswer((_) async => _testDetail);

    await tester.pumpWidget(
      createTestApp(repository: mockRepository, tvShowId: '1'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Breaking Bad'), findsWidgets);
  });

  testWidgets('shows error with retry button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tvShowDetailsProvider(1).overrideWithValue(
            AsyncValue.error(NetworkFailure(), StackTrace.current),
          ),
        ],
        child: const MaterialApp(home: TvShowDetailScreen(tvShowId: '1')),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);
    expect(
      find.text('No internet connection. Please check your network.'),
      findsOneWidget,
    );
    expect(find.textContaining('Instance of'), findsNothing);
  });
}
