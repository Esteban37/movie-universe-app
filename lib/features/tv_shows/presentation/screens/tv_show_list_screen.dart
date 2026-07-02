import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/media/tmdb_image_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/presentation/shell/primary_tab_app_bar.dart';
import '../../domain/entities/tv_show_entity.dart';
import '../../../../shared/mappers/media_display_mapper.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../providers/popular_tv_shows_provider.dart';
import '../providers/top_rated_tv_shows_provider.dart';
import '../widgets/tv_show_card.dart';

class TvShowListScreen extends ConsumerStatefulWidget {
  const TvShowListScreen({super.key});

  @override
  ConsumerState<TvShowListScreen> createState() => _TvShowListScreenState();
}

class _TvShowListScreenState extends ConsumerState<TvShowListScreen>
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
      appBar: PrimaryTabAppBar.build(
        title: 'Series',
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
          _TvShowTab(
            provider: popularTvShowsProvider,
            loadNextPage: () =>
                ref.read(popularTvShowsProvider.notifier).loadNextPage(),
            columnCount: _columnCount(MediaQuery.of(context).size.width),
          ),
          _TvShowTab(
            provider: topRatedTvShowsProvider,
            loadNextPage: () =>
                ref.read(topRatedTvShowsProvider.notifier).loadNextPage(),
            columnCount: _columnCount(MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }
}

class _TvShowTab extends ConsumerStatefulWidget {
  const _TvShowTab({
    required this.provider,
    required this.loadNextPage,
    required this.columnCount,
  });

  final AsyncNotifierProvider<
    AsyncNotifier<List<TvShowEntity>>,
    List<TvShowEntity>
  >
  provider;
  final VoidCallback loadNextPage;
  final int columnCount;

  @override
  ConsumerState<_TvShowTab> createState() => _TvShowTabState();
}

class _TvShowTabState extends ConsumerState<_TvShowTab> {
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
    final showsAsync = ref.watch(widget.provider);
    final imageUrls = ref.watch(tmdbImageUrlProvider);

    return showsAsync.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        failure: error is Failure
            ? error
            : UnexpectedFailure(details: error.toString()),
        onRetry: () => ref.invalidate(widget.provider),
      ),
      data: (shows) {
        if (shows.isEmpty) {
          return const EmptyView(message: 'No TV shows found.');
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
          itemCount: shows.length,
          itemBuilder: (context, index) {
            final show = shows[index];
            return TvShowCard(
              media: tvShowToMediaDisplayModel(show),
              imageUrls: imageUrls,
              onTap: () {
                AppRouter.pushTvShowDetail(context, '${show.id}');
              },
            );
          },
        );
      },
    );
  }
}
