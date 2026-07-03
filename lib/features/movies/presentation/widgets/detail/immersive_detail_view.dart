import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../../../../shared/presentation/detail/immersive_detail_view_template.dart';
import 'detail_content.dart';
import 'detail_header_delegate.dart';

class ImmersiveDetailView extends StatelessWidget {
  const ImmersiveDetailView({
    super.key,
    required this.details,
    required this.imageUrls,
  });

  final MovieDetailEntity details;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    return ImmersiveDetailViewTemplate(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      imageUrls: imageUrls,
      title: details.title,
      sliversBuilder: (context, layout) => [
        SliverPersistentHeader(
          delegate: DetailHeaderDelegate(
            backdropUrl: layout.backdropUrl,
            posterPath: layout.posterPath,
            imageUrls: layout.imageUrls,
            title: details.title,
            voteAverage: details.voteAverage,
            releaseDate: details.releaseDate,
            runtime: details.runtime,
            headerHeight: layout.headerHeight,
            collapseProgress: layout.collapseProgress,
            reducedMotion: layout.reducedMotion,
            isTablet: layout.isTablet,
          ),
        ),
        SliverToBoxAdapter(
          child: DetailContent(
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
