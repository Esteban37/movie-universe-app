import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/atoms/poster_image.dart';
import '../../../../../shared/widgets/hero_backdrop.dart';
import '../../../../../shared/presentation/detail/immersive_detail_constants.dart';
import 'immersive_tv_show_meta_row.dart';

class TvDetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  TvDetailHeaderDelegate({
    required this.backdropUrl,
    required this.posterPath,
    required this.imageUrls,
    required this.name,
    required this.voteAverage,
    required this.firstAirDate,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.headerHeight,
    required this.collapseProgress,
    required this.reducedMotion,
    required this.isTablet,
  });

  final String? backdropUrl;
  final String posterPath;
  final TmdbImageUrl imageUrls;
  final String name;
  final double voteAverage;
  final String firstAirDate;
  final int numberOfSeasons;
  final int numberOfEpisodes;
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
    final sizeProgress =
        (progress / ImmersiveDetailConstants.posterCrossoverStart).clamp(
          0.0,
          1.0,
        );
    final posterWidth =
        ImmersiveDetailConstants.expandedPosterWidth +
        ((ImmersiveDetailConstants.contentPosterWidth -
                ImmersiveDetailConstants.expandedPosterWidth) *
            sizeProgress);
    final posterHeight =
        ImmersiveDetailConstants.expandedPosterHeight +
        ((ImmersiveDetailConstants.contentPosterHeight -
                ImmersiveDetailConstants.expandedPosterHeight) *
            sizeProgress);
    final posterRadius = 8.0 - (4.0 * sizeProgress);
    final posterOpacity =
        (1.0 -
                (progress - ImmersiveDetailConstants.posterCrossoverStart) /
                    ImmersiveDetailConstants.posterCrossoverSpan)
            .clamp(0.0, 1.0);
    final heroTextOpacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final titleStyle = isTablet
        ? theme.textTheme.headlineMedium
        : theme.textTheme.headlineSmall;

    return Semantics(
      label: 'TV show backdrop for $name',
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
                semanticLabel: 'Backdrop for $name',
              )
            else
              Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.tv,
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
                      label: 'Poster for $name',
                      image: true,
                      child: PosterImage(
                        key: const ValueKey('tv-header-poster'),
                        path: posterPath,
                        width: posterWidth,
                        height: posterHeight,
                        size: TmdbPosterSize.large,
                        borderRadius: BorderRadius.circular(posterRadius),
                        imageUrls: imageUrls,
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
                          name,
                          style: titleStyle?.copyWith(
                            color: theme.colorScheme.onPrimary,
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
                        ImmersiveTvShowMetaRow(
                          voteAverage: voteAverage,
                          firstAirDate: firstAirDate,
                          numberOfSeasons: numberOfSeasons,
                          numberOfEpisodes: numberOfEpisodes,
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
  bool shouldRebuild(TvDetailHeaderDelegate oldDelegate) =>
      oldDelegate.collapseProgress != collapseProgress ||
      oldDelegate.backdropUrl != backdropUrl ||
      oldDelegate.posterPath != posterPath ||
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.reducedMotion != reducedMotion ||
      oldDelegate.isTablet != isTablet;
}
