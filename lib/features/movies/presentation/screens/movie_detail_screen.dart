import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_detail_entity.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hero_backdrop.dart';
import '../providers/movie_details_provider.dart';

const _phoneHeaderHeight = 300.0;
const _tabletHeaderHeight = 420.0;
const _phoneBreakpoint = 600.0;

class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(movieId) ?? 0;
    final detailsAsync = ref.watch(movieDetailsProvider(id));

    return Scaffold(
      body: detailsAsync.when(
        loading: () => const SkeletonLoader(variant: SkeletonVariant.detail),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(movieDetailsProvider(id)),
        ),
        data: (details) => _ImmersiveDetailView(details: details),
      ),
    );
  }
}

class _ImmersiveDetailView extends StatefulWidget {
  const _ImmersiveDetailView({required this.details});

  final MovieDetailEntity details;

  @override
  State<_ImmersiveDetailView> createState() => _ImmersiveDetailViewState();
}

class _ImmersiveDetailViewState extends State<_ImmersiveDetailView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _collapseProgress = ValueNotifier(0.0);

  late AnimationController _dismissController;
  double _dismissProgress = 0;
  bool _isDismissing = false;
  bool _reducedMotion = false;

  double get _headerHeight {
    final width = MediaQuery.of(context).size.width;
    return width < _phoneBreakpoint ? _phoneHeaderHeight : _tabletHeaderHeight;
  }

  double get _collapsedHeaderHeight =>
      MediaQuery.of(context).padding.top + kToolbarHeight;

  @override
  void initState() {
    super.initState();
    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(_onDismissAnimate);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _collapseProgress.dispose();
    _dismissController.removeListener(_onDismissAnimate);
    _dismissController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollRange = _headerHeight - _collapsedHeaderHeight;
    if (scrollRange <= 0) return;
    final progress = (_scrollController.offset / scrollRange).clamp(0.0, 1.0);
    _collapseProgress.value = progress;
  }

  void _onDismissAnimate() {
    setState(() {
      _dismissProgress = _dismissController.value;
    });
  }

  void _onDismissDragUpdate(DragUpdateDetails details) {
    if (_scrollController.offset > 0) return;
    if (details.delta.dy <= 0) return;

    setState(() {
      _isDismissing = true;
      _dismissProgress = (_dismissProgress + (details.delta.dy / 400)).clamp(
        0.0,
        1.0,
      );
    });
  }

  void _onDismissDragEnd(DragEndDetails details) {
    if (!_isDismissing) return;

    if (_dismissProgress >= 0.3) {
      _dismissController.value = _dismissProgress;
      _dismissController.animateTo(1.0, curve: Curves.easeInCubic).then((_) {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      _dismissController.value = _dismissProgress;
      _dismissController.animateTo(0.0, curve: Curves.easeOutCubic);
      setState(() => _isDismissing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    final backdropUrl = details.backdropPath != null
        ? 'https://image.tmdb.org/t/p/w780${details.backdropPath}'
        : null;
    final posterUrl = 'https://image.tmdb.org/t/p/w342${details.posterPath}';
    final theme = Theme.of(context);

    final dismissScale = 1.0 - (_dismissProgress * 0.08);
    final dismissTranslate = _dismissProgress * 200;

    return Semantics(
      explicitChildNodes: true,
      child: ValueListenableBuilder<double>(
        valueListenable: _collapseProgress,
        builder: (context, collapseProgress, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: theme.scaffoldBackgroundColor),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(
                  dismissScale,
                  dismissScale,
                  1.0,
                )..setTranslationRaw(0.0, dismissTranslate, 0.0),
                child: Scaffold(
                  backgroundColor: _dismissProgress > 0
                      ? Colors.transparent
                      : theme.scaffoldBackgroundColor,
                  body: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (_dismissProgress > 0) return false;
                      if (notification is OverscrollNotification &&
                          notification.overscroll > 0 &&
                          _scrollController.offset <= 0) {
                        _onDismissDragUpdate(
                          DragUpdateDetails(
                            globalPosition: Offset.zero,
                            delta: Offset(0, notification.overscroll),
                          ),
                        );
                      }
                      if (notification is ScrollEndNotification &&
                          _isDismissing) {
                        _onDismissDragEnd(DragEndDetails());
                      }
                      if (notification is ScrollEndNotification &&
                          _isDismissing) {
                        _onDismissDragEnd(DragEndDetails());
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: _dismissProgress > 0
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _DetailHeaderDelegate(
                            backdropUrl: backdropUrl,
                            posterUrl: posterUrl,
                            title: details.title,
                            voteAverage: details.voteAverage,
                            releaseDate: details.releaseDate,
                            runtime: details.runtime,
                            headerHeight: _headerHeight,
                            collapsedHeaderHeight: _collapsedHeaderHeight,
                            collapseProgress: collapseProgress,
                            reducedMotion: _reducedMotion,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _DetailContent(
                            details: details,
                            posterUrl: posterUrl,
                            collapseProgress: collapseProgress,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_dismissProgress > 0)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Back',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  _DetailHeaderDelegate({
    required this.backdropUrl,
    required this.posterUrl,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.headerHeight,
    required this.collapsedHeaderHeight,
    required this.collapseProgress,
    required this.reducedMotion,
  });

  final String? backdropUrl;
  final String posterUrl;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final double headerHeight;
  final double collapsedHeaderHeight;
  final double collapseProgress;
  final bool reducedMotion;

  @override
  double get minExtent => collapsedHeaderHeight;

  @override
  double get maxExtent => headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final heroOpacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    final posterWidth = 120.0 * (1.0 - progress);
    final posterHeight = 180.0 * (1.0 - progress);

    return Semantics(
      label: 'Movie backdrop for $title',
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            if (backdropUrl != null)
              HeroBackdrop(
                imageUrl: backdropUrl!,
                height: maxExtent,
                collapseProgress: reducedMotion ? 1.0 : progress,
                semanticLabel: 'Backdrop for $title',
              )
            else
              Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.movie,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Positioned(
              bottom: -1,
              left: 0,
              right: 0,
              top: 0,
              child: IgnorePointer(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        theme.scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (heroOpacity > 0)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: heroOpacity,
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (posterWidth > 0)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              posterUrl,
                              width: posterWidth,
                              height: posterHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: posterWidth,
                                height: posterHeight,
                                color: Colors.grey.shade800,
                                child: const Icon(Icons.movie, size: 48),
                              ),
                            ),
                          ),
                        if (posterWidth > 0) const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              _MovieMetaRow(
                                voteAverage: voteAverage,
                                releaseDate: releaseDate,
                                runtime: runtime,
                                lightText: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              left: 8,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: progress < 0.5
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'Add to favorites',
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: progress < 0.5
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                      onPressed: () {},
                      tooltip: 'Add to favorites',
                    ),
                  ),
                  Semantics(
                    label: 'More options',
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: progress < 0.5
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                      onPressed: () {},
                      tooltip: 'More options',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_DetailHeaderDelegate oldDelegate) =>
      oldDelegate.collapseProgress != collapseProgress ||
      oldDelegate.backdropUrl != backdropUrl ||
      oldDelegate.collapsedHeaderHeight != collapsedHeaderHeight;
}

class _MovieMetaRow extends StatelessWidget {
  const _MovieMetaRow({
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    this.lightText = false,
  });

  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final bool lightText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = lightText
        ? Colors.white.withValues(alpha: 0.85)
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return Row(
      children: [
        Semantics(
          label: 'Rating ${voteAverage.toStringAsFixed(1)} out of 10',
          child: Row(
            children: [
              const Icon(Icons.star, size: 18, color: Color(0xFFFFD700)),
              const SizedBox(width: 4),
              Text(
                voteAverage.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: lightText ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          releaseDate,
          style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor),
        ),
        if (runtime > 0) ...[
          const SizedBox(width: 8),
          Text(
            '$runtime min',
            style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor),
          ),
        ],
      ],
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.details,
    required this.posterUrl,
    required this.collapseProgress,
  });

  final MovieDetailEntity details;
  final String posterUrl;
  final double collapseProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showCompactHeader = collapseProgress > 0.5;
    final compactOpacity = ((collapseProgress - 0.5) / 0.3).clamp(0.0, 1.0);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCompactHeader)
              AnimatedOpacity(
                opacity: compactOpacity,
                duration: const Duration(milliseconds: 150),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        posterUrl,
                        width: 56,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 56,
                          height: 84,
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.movie, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _MovieMetaRow(
                            voteAverage: details.voteAverage,
                            releaseDate: details.releaseDate,
                            runtime: details.runtime,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (showCompactHeader) const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: details.genres
                  .map(
                    (genre) => Chip(
                      label: Text(
                        genre.name,
                        style: theme.textTheme.labelSmall,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
            if (details.tagline.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                details.tagline,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                details.overview,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
