import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/search_movies.dart';
import 'search_repository_provider.dart';

final searchMoviesProvider = Provider<SearchMovies>((ref) {
  return SearchMovies(ref.watch(searchRepositoryProvider));
});
