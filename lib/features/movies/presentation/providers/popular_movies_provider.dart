import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import 'movie_repository_provider.dart';

class PopularMoviesNotifier extends AsyncNotifier<List<MovieEntity>> {
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  @override
  Future<List<MovieEntity>> build() async {
    _currentPage = 1;
    return _fetchPage(1);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMorePages) return;
    _isLoadingMore = true;

    try {
      _currentPage++;
      final newMovies = await _fetchPage(_currentPage);
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

  Future<List<MovieEntity>> _fetchPage(int page) async {
    final repository = ref.read(movieRepositoryProvider);
    return repository.getPopular(page: page);
  }
}

final popularMoviesProvider =
    AsyncNotifierProvider<PopularMoviesNotifier, List<MovieEntity>>(
      PopularMoviesNotifier.new,
    );
