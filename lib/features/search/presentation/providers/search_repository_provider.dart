import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/network/dio_provider.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dataSource = SearchRemoteDataSource(ref.watch(dioProvider));
  return SearchRepositoryImpl(dataSource);
});
