import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/shared/design_system/models/media_display_model.dart';
import 'package:movie_universe_app/shared/design_system/models/movie_display_model.dart';

MovieDisplayModel toMovieDisplayModel(MovieEntity entity) {
  return MovieDisplayModel(
    id: entity.id,
    title: entity.title,
    posterPath: entity.posterPath,
    voteAverage: entity.voteAverage,
    releaseDate: entity.releaseDate,
  );
}

List<MovieDisplayModel> toMovieDisplayModels(List<MovieEntity> entities) {
  return entities.map(toMovieDisplayModel).toList();
}

MediaDisplayModel movieDisplayToMediaDisplayModel(MovieDisplayModel movie) {
  return MediaDisplayModel(
    id: movie.id,
    title: movie.title,
    posterPath: movie.posterPath,
    voteAverage: movie.voteAverage,
    subtitle: movie.releaseDate,
    mediaType: MediaType.movie,
  );
}

MediaDisplayModel movieEntityToMediaDisplayModel(MovieEntity entity) {
  return MediaDisplayModel(
    id: entity.id,
    title: entity.title,
    posterPath: entity.posterPath,
    voteAverage: entity.voteAverage,
    subtitle: entity.releaseDate,
    mediaType: MediaType.movie,
  );
}
