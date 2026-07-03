import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/shared/domain/entities/media_type.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/core/media/tmdb_image_provider.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_media_card.dart';
import 'package:movie_universe_app/shared/mappers/media_display_mapper.dart';
import 'package:movie_universe_app/shared/presentation/shell/primary_tab_app_bar.dart';
import 'package:movie_universe_app/shared/widgets/empty_view.dart';
import 'package:movie_universe_app/shared/widgets/error_view.dart';
import 'package:movie_universe_app/shared/widgets/loading_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadNextPage();
    }
  }

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  String _searchTargetLabel(MediaType? filter) {
    return switch (filter) {
      MediaType.movie => 'movies',
      MediaType.tvShow => 'series',
      null => 'movies and series',
    };
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final imageUrls = ref.watch(tmdbImageUrlProvider);
    final results = searchState.filteredItems;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PrimaryTabAppBar.build(
        title: 'Search',
        bottom: PrimaryTabAppBarBottom(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: searchState.filter == null,
                    onSelected: () =>
                        ref.read(searchProvider.notifier).setFilter(null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Movies',
                    selected: searchState.filter == MediaType.movie,
                    onSelected: () => ref
                        .read(searchProvider.notifier)
                        .setFilter(MediaType.movie),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Series',
                    selected: searchState.filter == MediaType.tvShow,
                    onSelected: () => ref
                        .read(searchProvider.notifier)
                        .setFilter(MediaType.tvShow),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText:
                      'Search ${_searchTargetLabel(searchState.filter)}...',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (query) {
                  ref.read(searchProvider.notifier).onQueryChanged(query);
                },
              ),
            ),
          ),
          Expanded(child: _buildBody(searchState, results, imageUrls)),
        ],
      ),
    );
  }

  Widget _buildBody(
    SearchViewState searchState,
    List<MediaItem> results,
    imageUrls,
  ) {
    if (searchState.isLoading) {
      return const LoadingView();
    }

    if (searchState.error != null) {
      return ErrorView(
        failure: searchState.error is Failure
            ? searchState.error! as Failure
            : UnexpectedFailure(details: searchState.error.toString()),
        onRetry: () => ref.read(searchProvider.notifier).retry(),
      );
    }

    if (_searchController.text.isNotEmpty && results.isEmpty) {
      final filterLabel = switch (searchState.filter) {
        MediaType.movie => 'movies',
        MediaType.tvShow => 'series',
        null => 'results',
      };
      return EmptyView(message: 'No $filterLabel found');
    }

    if (_searchController.text.isEmpty) {
      return EmptyView(
        message:
            'Start typing to search ${_searchTargetLabel(searchState.filter)}',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref
            .read(searchProvider.notifier)
            .onQueryChanged(_searchController.text);
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columnCount(MediaQuery.sizeOf(context).width),
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: results.length + (searchState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= results.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = results[index];
          final media = toMediaDisplayModel(item);

          return SearchMediaCard(
            key: ValueKey('${item.mediaType.name}-${item.id}'),
            media: media,
            imageUrls: imageUrls,
            onTap: () => _openDetail(context, item),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, MediaItem item) {
    switch (item) {
      case MovieMediaItem(:final movie):
        AppRouter.pushMovieDetail(context, '${movie.id}');
      case TvShowMediaItem(:final tvShow):
        AppRouter.pushTvShowDetail(context, '${tvShow.id}');
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
    );
  }
}
