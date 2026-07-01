import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/utils/debouncer.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';

class SearchNotifier extends Notifier<AsyncValue<List<MovieEntity>>> {
  Debouncer? _debouncer;
  String _query = '';

  @override
  AsyncValue<List<MovieEntity>> build() {
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    ref.onDispose(() => _debouncer?.cancel());
    return const AsyncData([]);
  }

  void onQueryChanged(String query) {
    _query = query;
    _debouncer?.cancel();

    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    _debouncer?.run(_performSearch);
  }

  Future<void> _performSearch() async {
    try {
      final result = await ref.read(searchRepositoryProvider).call(_query);
      state = AsyncData(result.results);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final searchProvider =
    NotifierProvider<SearchNotifier, AsyncValue<List<MovieEntity>>>(
      SearchNotifier.new,
    );
