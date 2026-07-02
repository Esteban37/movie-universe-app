import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_detail_entity.dart';
import '../../../../core/media/tmdb_image.dart';
import '../../../../core/media/tmdb_image_provider.dart';
import '../../../../shared/widgets/content_state.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/widgets/hero_backdrop.dart';
import '../providers/movie_details_provider.dart';

const _phoneHeaderHeight = 300.0;
const _tabletHeaderHeight = 420.0;
const _phoneBreakpoint = 600.0;
const _expandedPosterWidth = 120.0;
const _expandedPosterHeight = 180.0;
const _contentPosterWidth = 80.0;
const _contentPosterHeight = 120.0;

// Poster cross-fade window (in header collapse progress). The header poster
// shrinks to the content poster size by `_posterCrossoverStart`, then fades
// out over `_posterCrossoverSpan` while the content poster fades in over an
// overlapping window, producing a "same relative position" hand-off.
const _posterCrossoverStart = 0.35;
const _posterCrossoverSpan = 0.20;
const _contentPosterFadeStart = 0.40;
const _contentPosterFadeSpan = 0.22;

class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(movieId) ?? 0;
    final detailsAsync = ref.watch(movieDetailsProvider(id));

    return Scaffold(
      body: ContentState<MovieDetailEntity>(
        asyncValue: detailsAsync,
        onLoading: () => const SkeletonLoader(variant: SkeletonVariant.detail),
        onRetry: () => ref.invalidate(movieDetailsProvider(id)),
        onData: (details) {
          final imageUrls = ref.watch(tmdbImageUrlProvider);
          return _ImmersiveDetailView(details: details, imageUrls: imageUrls);
        },
      ),
    );
  }
}

class _ImmersiveDetailView extends StatefulWidget {
  const _ImmersiveDetailView({required this.details, required this.imageUrls});

  final MovieDetailEntity details;
  final TmdbImageUrl imageUrls;

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
    final scrollRange = _headerHeight;
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
      _isDismissing = false;
      _dismissController.value = _dismissProgress;
      _dismissController
          .animateTo(
            1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
          )
          .then((_) {
            if (mounted) Navigator.of(context).pop();
          });
    } else {
      _isDismissing = false;
      _dismissController.value = _dismissProgress;
      _dismissController
          .animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
            if (mounted) setState(() {});
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    final imageUrls = widget.imageUrls;
    final backdropUrl = imageUrls.backdrop(details.backdropPath);
    final posterUrl =
        imageUrls.poster(details.posterPath, size: TmdbPosterSize.large) ?? '';
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= _phoneBreakpoint;

    final dismissScale = 1.0 - (_dismissProgress * 0.08);
    final dismissTranslate = _dismissProgress * 200;
    final dismissRadius = _dismissProgress * 20;

    return Semantics(
      explicitChildNodes: true,
      child: ValueListenableBuilder<double>(
        valueListenable: _collapseProgress,
        builder: (context, collapseProgress, _) {
          return Stack(
            children: [
              // Own background fades out during dismiss so the non-opaque
              // route below (the movie list) shows through the gaps left by
              // the shrinking card.
              Positioned.fill(
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor.withValues(
                    alpha: 1 - _dismissProgress,
                  ),
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(
                  dismissScale,
                  dismissScale,
                  1.0,
                )..setTranslationRaw(0.0, dismissTranslate, 0.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dismissRadius),
                    boxShadow: _dismissProgress > 0
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withValues(
                                alpha: 0.4 * _dismissProgress,
                              ),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(dismissRadius),
                    child: Scaffold(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      body: Stack(
                        children: [
                          RepaintBoundary(
                            child: Listener(
                              onPointerMove: (event) {
                                _onDismissDragUpdate(
                                  DragUpdateDetails(
                                    globalPosition: event.position,
                                    delta: event.delta,
                                  ),
                                );
                              },
                              onPointerUp: (_) {
                                if (_isDismissing) {
                                  _onDismissDragEnd(DragEndDetails());
                                }
                              },
                              onPointerCancel: (_) {
                                if (_isDismissing) {
                                  _onDismissDragEnd(DragEndDetails());
                                }
                              },
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onVerticalDragUpdate: _onDismissDragUpdate,
                                onVerticalDragEnd: _onDismissDragEnd,
                                child: CustomScrollView(
                                  controller: _scrollController,
                                  physics: _dismissProgress > 0
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics(),
                                        ),
                                  slivers: [
                                    SliverPersistentHeader(
                                      delegate: _DetailHeaderDelegate(
                                        backdropUrl: backdropUrl,
                                        posterUrl: posterUrl,
                                        title: details.title,
                                        voteAverage: details.voteAverage,
                                        releaseDate: details.releaseDate,
                                        runtime: details.runtime,
                                        headerHeight: _headerHeight,
                                        collapseProgress: collapseProgress,
                                        reducedMotion: _reducedMotion,
                                        isTablet: isTablet,
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: _DetailContent(
                                        details: details,
                                        posterUrl: posterUrl,
                                        collapseProgress: collapseProgress,
                                        isTablet: isTablet,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _FloatingDetailAppBar(
                            backdropUrl: backdropUrl,
                            title: details.title,
                            collapseProgress: collapseProgress,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingDetailAppBar extends StatelessWidget {
  const _FloatingDetailAppBar({
    required this.backdropUrl,
    required this.title,
    required this.collapseProgress,
    required this.onBack,
  });

  final String? backdropUrl;
  final String title;
  final double collapseProgress;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    final backgroundOpacity = collapseProgress.clamp(0.0, 1.0);
    final titleOpacity = ((collapseProgress - 0.6) / 0.4).clamp(0.0, 1.0);
    final backgroundImageOpacity = ((collapseProgress - 0.35) / 0.35).clamp(
      0.0,
      1.0,
    );
    final foregroundColor = Color.lerp(
      colorScheme.onPrimary,
      colorScheme.onSurface,
      backgroundOpacity,
    )!;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Semantics(
        container: true,
        child: ClipRect(
          child: SizedBox(
            height: topPadding + kToolbarHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (backdropUrl != null)
                  Opacity(
                    opacity: backgroundImageOpacity,
                    child: Image.network(
                      backdropUrl!,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(
                      alpha: backdropUrl == null
                          ? backgroundOpacity
                          : backgroundOpacity * 0.72,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.shadow.withValues(
                          alpha: backgroundImageOpacity * 0.20,
                        ),
                        colorScheme.surface.withValues(
                          alpha: backgroundOpacity * 0.30,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: NavigationToolbar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: foregroundColor),
                      onPressed: onBack,
                      tooltip: 'Back',
                    ),
                    middle: Text(
                      title,
                      key: const ValueKey('collapsed-app-bar-title'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(
                          alpha: titleOpacity,
                        ),
                      ),
                    ),
                    // Balances the leading back button so the title stays
                    // visually centered. Favorite/menu actions were removed:
                    // they are out of scope for the exercise and were non-functional.
                    trailing: const SizedBox(width: 48),
                    centerMiddle: true,
                  ),
                ),
              ],
            ),
          ),
        ),
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
    required this.collapseProgress,
    required this.reducedMotion,
    required this.isTablet,
  });

  final String? backdropUrl;
  final String posterUrl;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final double headerHeight;
  final double collapseProgress;
  final bool reducedMotion;
  final bool isTablet;

  @override
  double get minExtent => 0;

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
    // The poster reaches the content poster's exact size/radius before the
    // hand-off begins, so the two posters share identical dimensions during
    // the cross-fade and read as a single element settling into place.
    final sizeProgress = (progress / _posterCrossoverStart).clamp(0.0, 1.0);
    final posterWidth =
        _expandedPosterWidth +
        ((_contentPosterWidth - _expandedPosterWidth) * sizeProgress);
    final posterHeight =
        _expandedPosterHeight +
        ((_contentPosterHeight - _expandedPosterHeight) * sizeProgress);
    final posterRadius = 8.0 - (4.0 * sizeProgress);
    // Poster fades out over its cross-fade window; the content poster fades in
    // over an overlapping window (see `_DetailContent`).
    final posterOpacity =
        (1.0 - (progress - _posterCrossoverStart) / _posterCrossoverSpan).clamp(
          0.0,
          1.0,
        );
    final heroTextOpacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final titleStyle = isTablet
        ? theme.textTheme.headlineMedium
        : theme.textTheme.headlineSmall;

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
                collapseProgress: progress,
                enableParallax: !reducedMotion,
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
            if (posterOpacity > 0)
              Positioned(
                bottom: 16,
                left: horizontalPadding,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: posterOpacity,
                    child: Semantics(
                      label: 'Poster for $title',
                      image: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(posterRadius),
                        child: Image.network(
                          posterUrl,
                          key: const ValueKey('header-poster'),
                          width: posterWidth,
                          height: posterHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: posterWidth,
                            height: posterHeight,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.movie,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (heroTextOpacity > 0)
              Positioned(
                bottom: 16,
                left: horizontalPadding + posterWidth + 16,
                right: horizontalPadding,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: heroTextOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: titleStyle?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: theme.colorScheme.shadow.withValues(
                                  alpha: 0.54,
                                ),
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
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.reducedMotion != reducedMotion ||
      oldDelegate.isTablet != isTablet;
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
    final colorScheme = theme.colorScheme;
    final mutedColor = lightText
        ? colorScheme.onPrimary.withValues(alpha: 0.85)
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Semantics(
          label: 'Rating ${voteAverage.toStringAsFixed(1)} out of 10',
          child: Row(
            children: [
              Icon(Icons.star, size: 18, color: colorScheme.tertiary),
              const SizedBox(width: 4),
              Text(
                voteAverage.toStringAsFixed(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: lightText ? colorScheme.onPrimary : null,
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
    required this.isTablet,
  });

  final MovieDetailEntity details;
  final String posterUrl;
  final double collapseProgress;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final topPadding = isTablet ? 24.0 : 16.0;
    final compactInfoOpacity =
        ((collapseProgress - _contentPosterFadeStart) / _contentPosterFadeSpan)
            .clamp(0.0, 1.0);
    final overviewStyle =
        (isTablet ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge)
            ?.copyWith(height: 1.6);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compactInfoOpacity > 0) ...[
              Opacity(
                key: const ValueKey('detail-info-row'),
                opacity: compactInfoOpacity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: 'Poster for ${details.title}',
                      image: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          posterUrl,
                          key: const ValueKey('content-poster'),
                          width: _contentPosterWidth,
                          height: _contentPosterHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: _contentPosterWidth,
                            height: _contentPosterHeight,
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.movie,
                              size: 24,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
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
                            style:
                                (isTablet
                                        ? theme.textTheme.headlineSmall
                                        : theme.textTheme.titleLarge)
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16),
            ],
            _StaggeredReveal(
              key: const ValueKey('detail-genre-chips'),
              child: Wrap(
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
            ),
            _StaggeredReveal(
              key: const ValueKey('detail-overview'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (details.tagline.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      details.tagline,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(details.overview, style: overviewStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Keeps content fully visible from first paint. A scroll-tied staggered
/// reveal was intentionally dropped: it hid below-the-fold content until the
/// user scrolled, which conflicts with the explicit requirement that the
/// movie information be visible immediately without scrolling.
class _StaggeredReveal extends StatelessWidget {
  const _StaggeredReveal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 1, child: child);
  }
}
