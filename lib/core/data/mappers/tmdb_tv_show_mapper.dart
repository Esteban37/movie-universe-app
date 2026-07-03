import 'package:movie_universe_app/core/data/dtos/tmdb_tv_show_dto.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

/// Maps shared TMDB TV list-item DTOs to domain entities.
class TmdbTvShowMapper {
  TmdbTvShowMapper._();

  static TvShowEntity toEntity(TmdbTvShowDto dto) {
    return TvShowEntity(
      id: dto.id,
      name: dto.name,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      firstAirDate: dto.firstAirDate ?? '',
      overview: dto.overview ?? '',
    );
  }

  static List<TvShowEntity> toEntityList(List<TmdbTvShowDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
