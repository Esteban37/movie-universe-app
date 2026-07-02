import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

class MockSearchMedia extends Mock implements SearchMedia {}

void main() {
  late MockSearchMedia mockSearchMedia;

  setUp(() {
    mockSearchMedia = MockSearchMedia();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
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
  });
}
