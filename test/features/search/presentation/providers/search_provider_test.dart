import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_movies.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWith((ref) => mockSearchMovies),
      ],
    );
  }

  group('SearchProvider', () {
    test('starts with empty data state', () {
      final container = createContainer();
      final state = container.read(searchProvider);
      expect(state, isA<AsyncData<List<MovieEntity>>>());
      expect(state.hasValue, isTrue);
      expect(state.value, isEmpty);
    });

    test('does not search when query is empty', () {
      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('');

      final state = container.read(searchProvider);
      expect(state, isA<AsyncData<List<MovieEntity>>>());
      expect(state.value, isEmpty);
      verifyNever(() => mockSearchMovies.call(any(), page: any(named: 'page')));
    });

    test('triggers search after debounce on non-empty query', () async {
      when(() => mockSearchMovies.call('test', page: 1)).thenAnswer(
        (_) async => const SearchResultEntity(
          page: 1,
          totalPages: 1,
          results: [
            MovieEntity(
              id: 1,
              title: 'Test Movie',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              releaseDate: '2024-01-01',
              overview: 'Overview',
            ),
          ],
        ),
      );

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('test');

      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(searchProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.title, 'Test Movie');
      verify(() => mockSearchMovies.call('test', page: 1)).called(1);
    });

    test(
      'clears results when query becomes empty after previous search',
      () async {
        final container = createContainer();
        final notifier = container.read(searchProvider.notifier);

        notifier.onQueryChanged('test');
        await Future.delayed(const Duration(milliseconds: 100));

        notifier.onQueryChanged('');

        await Future.delayed(const Duration(milliseconds: 100));

        final state = container.read(searchProvider);
        expect(state, isA<AsyncData<List<MovieEntity>>>());
        expect(state.value, isEmpty);
      },
    );

    test('handles error state', () async {
      when(
        () => mockSearchMovies.call('error', page: 1),
      ).thenThrow(Exception('API error'));

      final container = createContainer();
      final notifier = container.read(searchProvider.notifier);

      notifier.onQueryChanged('error');

      await Future.delayed(const Duration(milliseconds: 600));

      final state = container.read(searchProvider);
      expect(state, isA<AsyncError>());
    });
  });
}
