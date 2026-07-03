import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/tv_show_remote_datasource.dart';
import '../../data/repositories/tv_show_repository_impl.dart';
import '../../domain/repositories/tv_show_repository.dart';
import '../../../../core/network/dio_provider.dart';

final tvShowRepositoryProvider = Provider<TvShowRepository>((ref) {
  return TvShowRepositoryImpl(TvShowRemoteDataSource(ref.watch(dioProvider)));
});
