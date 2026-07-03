import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/shared/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

import '../../../../helpers/provider_container.dart';

class MockSearchMedia extends Mock implements SearchMedia {}

void main() {
  late MockSearchMedia mockSearchMedia;

  setUp(() {
    mockSearchMedia = MockSearchMedia();
  });

  ProviderContainer createContainer() {
    return createTestContainer(
      overrides: [
        searchMediaProvider.overrideWith((ref) => mockSearchMedia),
      ],
    );
  }

  group('PaginatedSearchNotifier', () {
    test('starts with empty state', () {
      final container = createContainer();
      final state = container.read(searchProvider);

      expect(state.items, isEmpty);
      expect(state.query, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('does not search when query is empty', () {
      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('');

      final state = container.read(searchProvider);
      expect(state.items, isEmpty);
      verifyNever(() => mockSearchMedia.call(any(), page: any(named: 'page')));
    });

    test('triggers search after debounce on non-empty query', () async {
      when(() => mockSearchMedia.call('test', page: 1)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 1,
          totalPages: 1,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 1,
                title: 'Test Movie',
                posterPath: '/poster.jpg',
                voteAverage: 7.5,
                releaseDate: '2024-01-01',
                overview: 'Overview',
              ),
            ),
          ],
        ),
      );

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('test');

      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(searchProvider);
      expect(state.items.length, 1);
      expect(state.items.first.title, 'Test Movie');
      verify(() => mockSearchMedia.call('test', page: 1)).called(1);
    });

    test('filters results client-side without refetching', () async {
      when(() => mockSearchMedia.call('test', page: 1)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 1,
          totalPages: 1,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 1,
                title: 'Movie',
                posterPath: '/m.jpg',
                voteAverage: 7.0,
                releaseDate: '2020-01-01',
                overview: 'Movie',
              ),
            ),
            MediaItem.tvShow(
              const TvShowEntity(
                id: 2,
                name: 'Series',
                posterPath: '/s.jpg',
                voteAverage: 8.0,
                firstAirDate: '2021-01-01',
                overview: 'Series',
              ),
            ),
          ],
        ),
      );

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('test');
      await Future.delayed(const Duration(milliseconds: 600));

      notifier.setFilter(MediaType.movie);

      final state = container.read(searchProvider);
      expect(state.items.length, 2);
      expect(state.filteredItems.length, 1);
      expect(state.filteredItems.first.title, 'Movie');
      verify(() => mockSearchMedia.call('test', page: 1)).called(1);
    });

    test('handles error state', () async {
      when(
        () => mockSearchMedia.call('error', page: 1),
      ).thenThrow(Exception('API error'));

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('error');

      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(searchProvider);
      expect(state.error, isNotNull);
      expect(state.isLoading, isFalse);
    });

    test('loadNextPage appends results when more pages exist', () async {
      when(() => mockSearchMedia.call('test', page: 1)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 1,
          totalPages: 2,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 1,
                title: 'Page 1 Movie',
                posterPath: '/p1.jpg',
                voteAverage: 7.0,
                releaseDate: '2024-01-01',
                overview: 'Page 1',
              ),
            ),
          ],
        ),
      );
      when(() => mockSearchMedia.call('test', page: 2)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 2,
          totalPages: 2,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 2,
                title: 'Page 2 Movie',
                posterPath: '/p2.jpg',
                voteAverage: 8.0,
                releaseDate: '2024-02-01',
                overview: 'Page 2',
              ),
            ),
          ],
        ),
      );

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('test');
      await Future.delayed(const Duration(milliseconds: 600));

      await notifier.loadNextPage();

      final state = container.read(searchProvider);
      expect(state.items.length, 2);
      expect(state.currentPage, 2);
      expect(state.items.last.title, 'Page 2 Movie');
      verify(() => mockSearchMedia.call('test', page: 1)).called(1);
      verify(() => mockSearchMedia.call('test', page: 2)).called(1);
    });

    test('loadNextPage does nothing when no more pages remain', () async {
      when(() => mockSearchMedia.call('test', page: 1)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 1,
          totalPages: 1,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 1,
                title: 'Only Page',
                posterPath: '/p1.jpg',
                voteAverage: 7.0,
                releaseDate: '2024-01-01',
                overview: 'Only',
              ),
            ),
          ],
        ),
      );

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('test');
      await Future.delayed(const Duration(milliseconds: 600));

      await notifier.loadNextPage();

      verify(() => mockSearchMedia.call('test', page: 1)).called(1);
      verifyNever(() => mockSearchMedia.call('test', page: 2));
    });

    test('retry re-runs search after failure', () async {
      when(
        () => mockSearchMedia.call('retry', page: 1),
      ).thenThrow(Exception('API error'));

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('retry');
      await Future.delayed(const Duration(milliseconds: 600));
      expect(container.read(searchProvider).error, isNotNull);

      when(() => mockSearchMedia.call('retry', page: 1)).thenAnswer(
        (_) async => SearchResultEntity(
          page: 1,
          totalPages: 1,
          results: [
            MediaItem.movie(
              const MovieEntity(
                id: 1,
                title: 'Recovered',
                posterPath: '/p.jpg',
                voteAverage: 7.0,
                releaseDate: '2024-01-01',
                overview: 'Recovered',
              ),
            ),
          ],
        ),
      );

      await notifier.retry();

      final state = container.read(searchProvider);
      expect(state.error, isNull);
      expect(state.items.single.title, 'Recovered');
      verify(() => mockSearchMedia.call('retry', page: 1)).called(2);
    });
  });
}
