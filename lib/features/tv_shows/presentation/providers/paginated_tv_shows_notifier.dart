import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_entity.dart';

abstract class PaginatedTvShowsNotifier extends AsyncNotifier<List<TvShowEntity>> {
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  Future<List<TvShowEntity>> fetchPage(int page);

  @override
  Future<List<TvShowEntity>> build() async {
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
      final newShows = await fetchPage(_currentPage);
      if (newShows.isEmpty) {
        _hasMorePages = false;
        _currentPage--;
      } else {
        state = AsyncData([...state.value ?? [], ...newShows]);
      }
    } catch (e, st) {
      _currentPage--;
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
