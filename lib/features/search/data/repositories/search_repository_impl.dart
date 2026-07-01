import 'package:dio/dio.dart';
import 'package:movie_universe_app/core/errors/error_handler.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
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
        results: response.results.map(_mapDTOToEntity).toList(),
        totalPages: response.totalPages,
      );
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  MovieEntity _mapDTOToEntity(MovieDTO dto) {
    return MovieEntity(
      id: dto.id,
      title: dto.title,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      releaseDate: dto.releaseDate ?? '',
      overview: dto.overview ?? '',
    );
  }
}
