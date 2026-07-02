import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_popular_tv_shows.dart';
import '../../domain/usecases/get_top_rated_tv_shows.dart';
import '../../domain/usecases/get_tv_show_details.dart';
import 'tv_show_repository_provider.dart';

final getPopularTvShowsProvider = Provider<GetPopularTvShows>((ref) {
  return GetPopularTvShows(ref.watch(tvShowRepositoryProvider));
});

final getTopRatedTvShowsProvider = Provider<GetTopRatedTvShows>((ref) {
  return GetTopRatedTvShows(ref.watch(tvShowRepositoryProvider));
});

final getTvShowDetailsProvider = Provider<GetTvShowDetails>((ref) {
  return GetTvShowDetails(ref.watch(tvShowRepositoryProvider));
});
