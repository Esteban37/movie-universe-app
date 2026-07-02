import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_detail_entity.dart';
import '../../../../core/media/tmdb_image_provider.dart';
import '../../../../shared/widgets/content_state.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../providers/tv_show_details_provider.dart';
import '../widgets/detail/immersive_tv_detail_view.dart';

class TvShowDetailScreen extends ConsumerWidget {
  const TvShowDetailScreen({super.key, required this.tvShowId});

  final String tvShowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(tvShowId) ?? 0;
    final detailsAsync = ref.watch(tvShowDetailsProvider(id));

    return Scaffold(
      body: ContentState<TvShowDetailEntity>(
        asyncValue: detailsAsync,
        onLoading: () => const SkeletonLoader(variant: SkeletonVariant.detail),
        onRetry: () => ref.invalidate(tvShowDetailsProvider(id)),
        onData: (details) {
          final imageUrls = ref.watch(tmdbImageUrlProvider);
          return ImmersiveTvDetailView(details: details, imageUrls: imageUrls);
        },
      ),
    );
  }
}
