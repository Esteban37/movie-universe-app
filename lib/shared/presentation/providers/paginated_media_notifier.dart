import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared infinite-scroll pagination logic for media list tabs.
abstract class PaginatedMediaNotifier<T> extends AsyncNotifier<List<T>> {
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  Future<List<T>> fetchPage(int page);

  @override
  Future<List<T>> build() async {
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
      final newItems = await fetchPage(_currentPage);
      if (newItems.isEmpty) {
        _hasMorePages = false;
        _currentPage--;
      } else {
        state = AsyncData([...state.value ?? [], ...newItems]);
      }
    } catch (e, st) {
      _currentPage--;
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
