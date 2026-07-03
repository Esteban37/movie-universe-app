import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/shared/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/shared/design_system/models/media_display_model.dart';

MediaDisplayModel toMediaDisplayModel(MediaItem item) {
  return MediaDisplayModel(
    id: item.id,
    title: item.title,
    posterPath: item.posterPath,
    voteAverage: item.voteAverage,
    subtitle: item.subtitle,
    mediaType: item.mediaType,
  );
}

MediaDisplayModel movieToMediaDisplayModel(MovieEntity entity) {
  return MediaDisplayModel(
    id: entity.id,
    title: entity.title,
    posterPath: entity.posterPath,
    voteAverage: entity.voteAverage,
    subtitle: entity.releaseDate,
    mediaType: MediaType.movie,
  );
}

MediaDisplayModel tvShowToMediaDisplayModel(TvShowEntity entity) {
  return MediaDisplayModel(
    id: entity.id,
    title: entity.name,
    posterPath: entity.posterPath,
    voteAverage: entity.voteAverage,
    subtitle: entity.firstAirDate,
    mediaType: MediaType.tvShow,
  );
}
