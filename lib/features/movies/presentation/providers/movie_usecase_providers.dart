import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import 'movie_repository_provider.dart';

final getPopularMoviesProvider = Provider<GetPopularMovies>((ref) {
  return GetPopularMovies(ref.watch(movieRepositoryProvider));
});

final getTopRatedMoviesProvider = Provider<GetTopRatedMovies>((ref) {
  return GetTopRatedMovies(ref.watch(movieRepositoryProvider));
});

final getMovieDetailsProvider = Provider<GetMovieDetails>((ref) {
  return GetMovieDetails(ref.watch(movieRepositoryProvider));
});
