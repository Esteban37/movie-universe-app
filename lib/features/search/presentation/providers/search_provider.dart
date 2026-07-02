import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/core/utils/debouncer.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';

class SearchViewState {
  const SearchViewState({
    this.items = const [],
    this.query = '',
    this.currentPage = 0,
    this.totalPages = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.filter,
  });

  final List<MediaItem> items;
  final String query;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;
  final MediaType? filter;

  bool get hasMorePages => currentPage < totalPages;

  List<MediaItem> get filteredItems {
    return switch (filter) {
      MediaType.movie => items.whereType<MovieMediaItem>().toList(),
      MediaType.tvShow => items.whereType<TvShowMediaItem>().toList(),
      null => items,
    };
  }

  SearchViewState copyWith({
    List<MediaItem>? items,
    String? query,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    MediaType? filter,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return SearchViewState(
      items: items ?? this.items,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      filter: clearFilter ? null : (filter ?? this.filter),
    );
  }
}

class PaginatedSearchNotifier extends Notifier<SearchViewState> {
  Debouncer? _debouncer;

  @override
  SearchViewState build() {
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    ref.onDispose(() => _debouncer?.cancel());
    return const SearchViewState();
  }

  void onQueryChanged(String query) {
    _debouncer?.cancel();

    if (query.isEmpty) {
      state = const SearchViewState();
      return;
    }

    state = SearchViewState(
      query: query,
      isLoading: true,
      filter: state.filter,
    );
    _debouncer?.run(() => _performSearch(reset: true));
  }

  void setFilter(MediaType? filter) {
    state = state.copyWith(filter: filter, clearFilter: filter == null);
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMorePages || state.query.isEmpty) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await ref.read(searchMediaProvider).call(
        state.query,
        page: nextPage,
      );

      state = state.copyWith(
        items: [...state.items, ...result.results],
        currentPage: result.page,
        totalPages: result.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  Future<void> retry() async {
    if (state.query.isEmpty) return;
    await _performSearch(reset: true);
  }

  Future<void> _performSearch({required bool reset}) async {
    try {
      final result = await ref.read(searchMediaProvider).call(state.query);
      state = state.copyWith(
        items: result.results,
        currentPage: result.page,
        totalPages: result.totalPages,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final searchProvider = NotifierProvider<PaginatedSearchNotifier, SearchViewState>(
  PaginatedSearchNotifier.new,
);
