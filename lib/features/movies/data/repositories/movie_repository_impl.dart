import 'package:dio/dio.dart';
import 'package:movie_universe_app/core/errors/error_handler.dart';
import 'package:movie_universe_app/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._dataSource);
  final MovieRemoteDataSource _dataSource;

  @override
  Future<List<MovieEntity>> getPopular({int page = 1}) async {
    try {
      final response = await _dataSource.getPopular(page: page);
      return response.results.map((dto) => _mapMovieDTOToEntity(dto)).toList();
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  @override
  Future<List<MovieEntity>> getTopRated({int page = 1}) async {
    try {
      final response = await _dataSource.getTopRated(page: page);
      return response.results.map((dto) => _mapMovieDTOToEntity(dto)).toList();
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  @override
  Future<MovieDetailEntity> getMovieDetails(int movieId) async {
    try {
      final dto = await _dataSource.getMovieDetails(movieId);
      return _mapMovieDetailDTOToEntity(dto);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  MovieEntity _mapMovieDTOToEntity(MovieDTO dto) {
    return MovieEntity(
      id: dto.id,
      title: dto.title,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      releaseDate: dto.releaseDate ?? '',
      overview: dto.overview ?? '',
    );
  }

  MovieDetailEntity _mapMovieDetailDTOToEntity(MovieDetailDTO dto) {
    return MovieDetailEntity(
      id: dto.id,
      title: dto.title,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      releaseDate: dto.releaseDate ?? '',
      overview: dto.overview ?? '',
      backdropPath: dto.backdropPath,
      genres: dto.genres.map((g) => Genre(id: g.id, name: g.name)).toList(),
      runtime: dto.runtime,
      tagline: dto.tagline,
    );
  }
}
