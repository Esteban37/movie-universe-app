import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';

/// Shared infinite-scroll pagination logic for movie list tabs.
abstract class PaginatedMoviesNotifier extends AsyncNotifier<List<MovieEntity>> {
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  Future<List<MovieEntity>> fetchPage(int page);

  @override
  Future<List<MovieEntity>> build() async {
    _currentPage = 1;
    _isLoadingMore = false;
    _hasMorePages = true;
    return fetchPage(1);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMorePages) return;
    _isLoadingMore = true;

    try {
      _currentPage++;
      final newMovies = await fetchPage(_currentPage);
      if (newMovies.isEmpty) {
        _hasMorePages = false;
        _currentPage--;
      } else {
        state = AsyncData([...state.value ?? [], ...newMovies]);
      }
    } catch (e, st) {
      _currentPage--;
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
