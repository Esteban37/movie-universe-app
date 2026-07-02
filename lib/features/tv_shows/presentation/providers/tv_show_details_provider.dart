import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tv_show_detail_entity.dart';
import 'tv_show_usecase_providers.dart';

final tvShowDetailsProvider =
    FutureProvider.family<TvShowDetailEntity, int>((ref, tvShowId) async {
      final getDetails = ref.watch(getTvShowDetailsProvider);
      return getDetails(tvShowId);
    });
