import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_detail_entity.dart';
import 'movie_usecase_providers.dart';

final movieDetailsProvider = FutureProvider.family<MovieDetailEntity, int>((
  ref,
  movieId,
) async {
  final getDetails = ref.watch(getMovieDetailsProvider);
  return getDetails(movieId);
});
