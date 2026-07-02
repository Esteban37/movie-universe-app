import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
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
