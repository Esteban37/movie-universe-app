import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_entity.dart';
import '../../../../shared/presentation/providers/paginated_media_notifier.dart';
import 'tv_show_usecase_providers.dart';

class TopRatedTvShowsNotifier extends PaginatedMediaNotifier<TvShowEntity> {
  @override
  Future<List<TvShowEntity>> fetchPage(int page) {
    return ref.read(getTopRatedTvShowsProvider)(page: page);
  }
}

final topRatedTvShowsProvider =
    AsyncNotifierProvider<TopRatedTvShowsNotifier, List<TvShowEntity>>(
      TopRatedTvShowsNotifier.new,
    );
