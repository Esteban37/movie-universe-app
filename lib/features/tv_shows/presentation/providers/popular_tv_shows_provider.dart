import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_entity.dart';
import '../../../../shared/presentation/providers/paginated_media_notifier.dart';
import 'tv_show_usecase_providers.dart';

class PopularTvShowsNotifier extends PaginatedMediaNotifier<TvShowEntity> {
  @override
  Future<List<TvShowEntity>> fetchPage(int page) {
    return ref.read(getPopularTvShowsProvider)(page: page);
  }
}

final popularTvShowsProvider =
    AsyncNotifierProvider<PopularTvShowsNotifier, List<TvShowEntity>>(
      PopularTvShowsNotifier.new,
    );
