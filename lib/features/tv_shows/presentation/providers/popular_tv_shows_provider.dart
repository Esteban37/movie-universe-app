import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_entity.dart';
import 'paginated_tv_shows_notifier.dart';
import 'tv_show_usecase_providers.dart';

class PopularTvShowsNotifier extends PaginatedTvShowsNotifier {
  @override
  Future<List<TvShowEntity>> fetchPage(int page) {
    return ref.read(getPopularTvShowsProvider)(page: page);
  }
}

final popularTvShowsProvider =
    AsyncNotifierProvider<PopularTvShowsNotifier, List<TvShowEntity>>(
      PopularTvShowsNotifier.new,
    );
