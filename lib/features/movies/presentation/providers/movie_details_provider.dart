import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_detail_entity.dart';
import 'movie_repository_provider.dart';

final movieDetailsProvider =
    FutureProvider.family<MovieDetailEntity, int>((ref, movieId) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovieDetails(movieId);
});
