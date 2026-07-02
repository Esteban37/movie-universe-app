import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluro/fluro.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/movie_entity.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../providers/popular_movies_provider.dart';
import '../providers/top_rated_movies_provider.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search movies',
            onPressed: () {
              FluroRouter.appRouter.navigateTo(
                context,
                '/search',
                transition: TransitionType.fadeIn,
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MovieTab(
            provider: popularMoviesProvider,
            loadNextPage: () =>
                ref.read(popularMoviesProvider.notifier).loadNextPage(),
            columnCount: _columnCount(MediaQuery.of(context).size.width),
          ),
          _MovieTab(
            provider: topRatedMoviesProvider,
            loadNextPage: () =>
                ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
            columnCount: _columnCount(MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }
}

class _MovieTab extends ConsumerStatefulWidget {
  const _MovieTab({
    required this.provider,
    required this.loadNextPage,
    required this.columnCount,
  });

  final AsyncNotifierProvider<
    AsyncNotifier<List<MovieEntity>>,
    List<MovieEntity>
  >
  provider;
  final VoidCallback loadNextPage;
  final int columnCount;

  @override
  ConsumerState<_MovieTab> createState() => _MovieTabState();
}

class _MovieTabState extends ConsumerState<_MovieTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(widget.provider);

    return moviesAsync.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        failure: error is Failure
            ? error
            : UnexpectedFailure(details: error.toString()),
        onRetry: () => ref.invalidate(widget.provider),
      ),
      data: (movies) {
        if (movies.isEmpty) {
          return const EmptyView(message: 'No movies found.');
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columnCount,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () {
                AppRouter.pushMovieDetail(context, '${movie.id}');
              },
            );
          },
        );
      },
    );
  }
}
