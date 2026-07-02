import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/environment_config_provider.dart';
import 'tmdb_image.dart';

final tmdbImageUrlProvider = Provider<TmdbImageUrl>((ref) {
  final imageBaseUrl = ref.watch(environmentConfigProvider).imageBaseUrl;
  return TmdbImageUrl(imageBaseUrl);
});
