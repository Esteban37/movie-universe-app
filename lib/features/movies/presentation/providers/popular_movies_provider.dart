import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import '../../../../shared/presentation/providers/paginated_media_notifier.dart';
import 'movie_usecase_providers.dart';

class PopularMoviesNotifier extends PaginatedMediaNotifier<MovieEntity> {
  @override
  Future<List<MovieEntity>> fetchPage(int page) {
    return ref.read(getPopularMoviesProvider)(page: page);
  }
}

final popularMoviesProvider =
    AsyncNotifierProvider<PopularMoviesNotifier, List<MovieEntity>>(
      PopularMoviesNotifier.new,
    );
