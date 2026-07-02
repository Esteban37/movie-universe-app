import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/search_media.dart';
import 'search_repository_provider.dart';

final searchMediaProvider = Provider<SearchMedia>((ref) {
  return SearchMedia(ref.watch(searchRepositoryProvider));
});
