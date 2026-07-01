import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_universe_app/core/network/dio_provider.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_movies.dart';

final searchRepositoryProvider = Provider<SearchMovies>((ref) {
  final dataSource = SearchRemoteDataSource(ref.watch(dioProvider));
  final repository = SearchRepositoryImpl(dataSource);
  return SearchMovies(repository);
});
