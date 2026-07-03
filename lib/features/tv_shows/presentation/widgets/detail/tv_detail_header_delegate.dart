import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/templates/immersive_detail_header_delegate.dart';
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

  ImmersiveDetailHeaderDelegate get _inner => ImmersiveDetailHeaderDelegate(
    backdropUrl: backdropUrl,
    posterPath: posterPath,
    imageUrls: imageUrls,
    title: name,
    headerHeight: headerHeight,
    collapseProgress: collapseProgress,
    reducedMotion: reducedMotion,
    isTablet: isTablet,
    fallbackIcon: Icons.tv,
    backdropSemanticsLabel: 'TV show backdrop for $name',
    posterKey: const ValueKey('tv-header-poster'),
    metaRow: ImmersiveTvShowMetaRow(
      voteAverage: voteAverage,
      firstAirDate: firstAirDate,
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
      lightText: true,
    ),
  );

  @override
  double get minExtent => _inner.minExtent;

  @override
  double get maxExtent => _inner.maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      _inner.build(context, shrinkOffset, overlapsContent);

  @override
  bool shouldRebuild(TvDetailHeaderDelegate oldDelegate) =>
      oldDelegate.collapseProgress != collapseProgress ||
      oldDelegate.backdropUrl != backdropUrl ||
      oldDelegate.posterPath != posterPath ||
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.reducedMotion != reducedMotion ||
      oldDelegate.isTablet != isTablet ||
      oldDelegate.name != name;
}
