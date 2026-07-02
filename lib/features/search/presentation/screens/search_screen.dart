import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_provider.dart';
import 'package:movie_universe_app/features/search/presentation/widgets/search_result_card.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
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
          message: error.toString(),
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
                  SearchResultCard(movie: movies[index]),
            ),
          );
        },
      ),
    );
  }
}
