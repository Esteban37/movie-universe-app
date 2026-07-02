import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import 'movie_usecase_providers.dart';
import 'paginated_movies_notifier.dart';

class PopularMoviesNotifier extends PaginatedMoviesNotifier {
  @override
  Future<List<MovieEntity>> fetchPage(int page) {
    return ref.read(getPopularMoviesProvider)(page: page);
  }
}

final popularMoviesProvider =
    AsyncNotifierProvider<PopularMoviesNotifier, List<MovieEntity>>(
      PopularMoviesNotifier.new,
    );
