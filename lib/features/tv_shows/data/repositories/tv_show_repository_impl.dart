import 'package:dio/dio.dart';
import 'package:movie_universe_app/core/data/mappers/tmdb_tv_show_mapper.dart';
import 'package:movie_universe_app/core/errors/error_handler.dart';
import 'package:movie_universe_app/features/tv_shows/data/datasources/tv_show_remote_datasource.dart';
import 'package:movie_universe_app/features/tv_shows/data/dtos/tv_show_detail_dto.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';

class TvShowRepositoryImpl implements TvShowRepository {
  TvShowRepositoryImpl(this._dataSource);

  final TvShowRemoteDataSource _dataSource;

  @override
  Future<List<TvShowEntity>> getPopular({int page = 1}) async {
    try {
      final response = await _dataSource.getPopular(page: page);
      return TmdbTvShowMapper.toEntityList(response.results);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  @override
  Future<List<TvShowEntity>> getTopRated({int page = 1}) async {
    try {
      final response = await _dataSource.getTopRated(page: page);
      return TmdbTvShowMapper.toEntityList(response.results);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  @override
  Future<TvShowDetailEntity> getTvShowDetails(int tvShowId) async {
    try {
      final dto = await _dataSource.getTvShowDetails(tvShowId);
      return _mapDetailDtoToEntity(dto);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }

  TvShowDetailEntity _mapDetailDtoToEntity(TvShowDetailDTO dto) {
    return TvShowDetailEntity(
      id: dto.id,
      name: dto.name,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      firstAirDate: dto.firstAirDate ?? '',
      overview: dto.overview ?? '',
      backdropPath: dto.backdropPath,
      genres: dto.genres
          .map((g) => TvGenre(id: g.id, name: g.name))
          .toList(),
      tagline: dto.tagline,
      numberOfSeasons: dto.numberOfSeasons,
      numberOfEpisodes: dto.numberOfEpisodes,
      status: dto.status,
      networks: dto.networks.map((n) => n.name).toList(),
    );
  }
}
