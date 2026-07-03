import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../../../shared/design_system/templates/immersive_detail_header_delegate.dart';
import 'immersive_movie_meta_row.dart';

class DetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  DetailHeaderDelegate({
    required this.backdropUrl,
    required this.posterPath,
    required this.imageUrls,
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
  final String posterPath;
  final TmdbImageUrl imageUrls;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final double headerHeight;
  final double collapseProgress;
  final bool reducedMotion;
  final bool isTablet;

  ImmersiveDetailHeaderDelegate get _inner => ImmersiveDetailHeaderDelegate(
    backdropUrl: backdropUrl,
    posterPath: posterPath,
    imageUrls: imageUrls,
    title: title,
    headerHeight: headerHeight,
    collapseProgress: collapseProgress,
    reducedMotion: reducedMotion,
    isTablet: isTablet,
    fallbackIcon: Icons.movie,
    backdropSemanticsLabel: 'Movie backdrop for $title',
    posterKey: const ValueKey('header-poster'),
    metaRow: ImmersiveMovieMetaRow(
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      runtime: runtime,
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
  bool shouldRebuild(DetailHeaderDelegate oldDelegate) =>
      oldDelegate.collapseProgress != collapseProgress ||
      oldDelegate.backdropUrl != backdropUrl ||
      oldDelegate.posterPath != posterPath ||
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.reducedMotion != reducedMotion ||
      oldDelegate.isTablet != isTablet ||
      oldDelegate.title != title;
}
