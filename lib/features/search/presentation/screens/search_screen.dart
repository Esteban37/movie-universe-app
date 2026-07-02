import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/media/tmdb_image_provider.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_result_card.dart';
import 'package:movie_universe_app/shared/mappers/movie_display_mapper.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(searchProvider);
    final imageUrls = ref.watch(tmdbImageUrlProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            ref.read(searchProvider.notifier).onQueryChanged(query);
          },
        ),
      ),
      body: moviesAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          failure: error is Failure
              ? error
              : UnexpectedFailure(details: error.toString()),
          onRetry: () => ref
              .read(searchProvider.notifier)
              .onQueryChanged(_searchController.text),
        ),
        data: (movies) {
          if (_searchController.text.isNotEmpty && movies.isEmpty) {
            return const EmptyView(message: 'No results found');
          }
          if (movies.isEmpty) {
            return const EmptyView(message: 'Start typing to search movies');
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(searchProvider.notifier)
                  .onQueryChanged(_searchController.text);
            },
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) =>
                  SearchResultCard(
                    movie: toMovieDisplayModel(movies[index]),
                    imageUrls: imageUrls,
                  ),
            ),
          );
        },
      ),
    );
  }
}
