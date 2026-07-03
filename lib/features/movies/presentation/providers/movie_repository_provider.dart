import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../../../core/network/dio_provider.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(MovieRemoteDataSource(ref.watch(dioProvider)));
});
