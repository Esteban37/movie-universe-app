import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/popular_tv_shows_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';

import '../../../../helpers/provider_container.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

void main() {
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
  });

  ProviderContainer createContainer() {
    return createTestContainer(
      overrides: [
        tvShowRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  }

  group('PopularTvShowsProvider', () {
    test('loads first page on initialization', () async {
      when(() => mockRepository.getPopular(page: 1)).thenAnswer(
        (_) async => [
          const TvShowEntity(
            id: 1,
            name: 'Show 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            firstAirDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );

      final container = createContainer();

      final result = await container.read(popularTvShowsProvider.future);

      expect(result.length, 1);
      expect(result.first.name, 'Show 1');
      verify(() => mockRepository.getPopular(page: 1)).called(1);
    });

    test('loadNextPage appends shows and updates state', () async {
      const page1Shows = [
        TvShowEntity(
          id: 1,
          name: 'Show 1',
          posterPath: '/poster1.jpg',
          voteAverage: 7.5,
          firstAirDate: '2024-01-01',
          overview: 'Overview 1',
        ),
      ];
      const page2Shows = [
        TvShowEntity(
          id: 2,
          name: 'Show 2',
          posterPath: '/poster2.jpg',
          voteAverage: 8.0,
          firstAirDate: '2024-02-01',
          overview: 'Overview 2',
        ),
      ];

      when(
        () => mockRepository.getPopular(page: 1),
      ).thenAnswer((_) async => page1Shows);
      when(
        () => mockRepository.getPopular(page: 2),
      ).thenAnswer((_) async => page2Shows);

      final container = createContainer();

      await container.read(popularTvShowsProvider.future);

      await container.read(popularTvShowsProvider.notifier).loadNextPage();

      final state = container.read(popularTvShowsProvider);
      expect(state.value, [page1Shows[0], page2Shows[0]]);

      verify(() => mockRepository.getPopular(page: 1)).called(1);
      verify(() => mockRepository.getPopular(page: 2)).called(1);
    });

    test('prevents duplicate page loads', () async {
      when(() => mockRepository.getPopular(page: 1)).thenAnswer(
        (_) async => [
          const TvShowEntity(
            id: 1,
            name: 'Show 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            firstAirDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );
      when(() => mockRepository.getPopular(page: 2)).thenAnswer(
        (_) async => [
          const TvShowEntity(
            id: 2,
            name: 'Show 2',
            posterPath: '/poster2.jpg',
            voteAverage: 8.0,
            firstAirDate: '2024-02-01',
            overview: 'Overview 2',
          ),
        ],
      );

      final container = createContainer();

      await container.read(popularTvShowsProvider.future);

      final notifier = container.read(popularTvShowsProvider.notifier);

      await Future.wait([
        notifier.loadNextPage(),
        notifier.loadNextPage(),
        notifier.loadNextPage(),
      ]);

      verify(() => mockRepository.getPopular(page: 2)).called(1);
    });

    test('loadNextPage handles empty response as end of list', () async {
      when(() => mockRepository.getPopular(page: 1)).thenAnswer(
        (_) async => [
          const TvShowEntity(
            id: 1,
            name: 'Show 1',
            posterPath: '/poster1.jpg',
            voteAverage: 7.5,
            firstAirDate: '2024-01-01',
            overview: 'Overview 1',
          ),
        ],
      );
      when(
        () => mockRepository.getPopular(page: 2),
      ).thenAnswer((_) async => []);

      final container = createContainer();

      await container.read(popularTvShowsProvider.future);

      final notifier = container.read(popularTvShowsProvider.notifier);

      await notifier.loadNextPage();

      final state = container.read(popularTvShowsProvider);
      expect(state.value?.length, 1);

      await notifier.loadNextPage();

      verify(() => mockRepository.getPopular(page: 2)).called(1);
    });
  });
}
