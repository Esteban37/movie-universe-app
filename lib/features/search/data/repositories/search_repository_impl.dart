import 'package:dio/dio.dart';
import 'package:movie_universe_app/core/data/mappers/tmdb_movie_mapper.dart';
import 'package:movie_universe_app/core/errors/error_handler.dart';
import 'package:movie_universe_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._dataSource);

  final SearchRemoteDataSource _dataSource;

  @override
  Future<SearchResultEntity> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dataSource.search(query, page: page);
      return SearchResultEntity(
        page: response.page,
        results: TmdbMovieMapper.toEntityList(response.results),
        totalPages: response.totalPages,
      );
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }
}
