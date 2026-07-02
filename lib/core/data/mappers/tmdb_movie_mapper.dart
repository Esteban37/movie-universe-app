import 'package:movie_universe_app/core/data/dtos/tmdb_movie_dto.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

/// Maps shared TMDB list-item DTOs to domain entities.
class TmdbMovieMapper {
  TmdbMovieMapper._();

  static MovieEntity toEntity(TmdbMovieDto dto) {
    return MovieEntity(
      id: dto.id,
      title: dto.title,
      posterPath: dto.posterPath ?? '',
      voteAverage: dto.voteAverage,
      releaseDate: dto.releaseDate ?? '',
      overview: dto.overview ?? '',
    );
  }

  static List<MovieEntity> toEntityList(List<TmdbMovieDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
