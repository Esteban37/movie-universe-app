import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import 'movie_usecase_providers.dart';
import 'paginated_movies_notifier.dart';

class TopRatedMoviesNotifier extends PaginatedMoviesNotifier {
  @override
  Future<List<MovieEntity>> fetchPage(int page) {
    return ref.read(getTopRatedMoviesProvider)(page: page);
  }
}

final topRatedMoviesProvider =
    AsyncNotifierProvider<TopRatedMoviesNotifier, List<MovieEntity>>(
      TopRatedMoviesNotifier.new,
    );
