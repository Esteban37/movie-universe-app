import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../domain/entities/tv_show_detail_entity.dart';
import '../../../../../shared/presentation/detail/immersive_detail_view_template.dart';
import 'tv_detail_content.dart';
import 'tv_detail_header_delegate.dart';

class ImmersiveTvDetailView extends StatelessWidget {
  const ImmersiveTvDetailView({
    super.key,
    required this.details,
    required this.imageUrls,
  });

  final TvShowDetailEntity details;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    return ImmersiveDetailViewTemplate(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      imageUrls: imageUrls,
      title: details.name,
      sliversBuilder: (context, layout) => [
        SliverPersistentHeader(
          delegate: TvDetailHeaderDelegate(
            backdropUrl: layout.backdropUrl,
            posterPath: layout.posterPath,
            imageUrls: layout.imageUrls,
            name: details.name,
            voteAverage: details.voteAverage,
            firstAirDate: details.firstAirDate,
            numberOfSeasons: details.numberOfSeasons,
            numberOfEpisodes: details.numberOfEpisodes,
            headerHeight: layout.headerHeight,
            collapseProgress: layout.collapseProgress,
            reducedMotion: layout.reducedMotion,
            isTablet: layout.isTablet,
          ),
        ),
        SliverToBoxAdapter(
          child: TvDetailContent(
            details: details,
            posterPath: layout.posterPath,
            imageUrls: layout.imageUrls,
            collapseProgress: layout.collapseProgress,
            isTablet: layout.isTablet,
          ),
        ),
      ],
    );
  }
}
