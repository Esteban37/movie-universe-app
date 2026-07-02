import 'package:flutter/material.dart';

import '../../../../../shared/widgets/hero_backdrop.dart';
import 'immersive_detail_constants.dart';
import 'immersive_movie_meta_row.dart';

class DetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  DetailHeaderDelegate({
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
    // Poster fades out over its cross-fade window; the content poster fades in
    // over an overlapping window (see [DetailContent]).
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
                        ImmersiveMovieMetaRow(
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
  bool shouldRebuild(DetailHeaderDelegate oldDelegate) =>
      oldDelegate.collapseProgress != collapseProgress ||
      oldDelegate.backdropUrl != backdropUrl ||
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.reducedMotion != reducedMotion ||
      oldDelegate.isTablet != isTablet;
}
