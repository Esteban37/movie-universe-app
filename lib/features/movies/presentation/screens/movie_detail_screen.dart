import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_detail_entity.dart';
import '../../../../core/media/tmdb_image_provider.dart';
import '../../../../shared/widgets/content_state.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../providers/movie_details_provider.dart';
import '../widgets/detail/immersive_detail_view.dart';

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
          return ImmersiveDetailView(details: details, imageUrls: imageUrls);
        },
      ),
    );
  }
}
