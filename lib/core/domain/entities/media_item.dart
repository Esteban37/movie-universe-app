import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/core/domain/entities/media_type.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

part 'media_item.freezed.dart';

@freezed
sealed class MediaItem with _$MediaItem {
  const factory MediaItem.movie(MovieEntity movie) = MovieMediaItem;
  const factory MediaItem.tvShow(TvShowEntity tvShow) = TvShowMediaItem;
}

extension MediaItemX on MediaItem {
  MediaType get mediaType => switch (this) {
    MovieMediaItem() => MediaType.movie,
    TvShowMediaItem() => MediaType.tvShow,
  };

  int get id => switch (this) {
    MovieMediaItem(:final movie) => movie.id,
    TvShowMediaItem(:final tvShow) => tvShow.id,
  };

  String get title => switch (this) {
    MovieMediaItem(:final movie) => movie.title,
    TvShowMediaItem(:final tvShow) => tvShow.name,
  };

  String get posterPath => switch (this) {
    MovieMediaItem(:final movie) => movie.posterPath,
    TvShowMediaItem(:final tvShow) => tvShow.posterPath,
  };

  double get voteAverage => switch (this) {
    MovieMediaItem(:final movie) => movie.voteAverage,
    TvShowMediaItem(:final tvShow) => tvShow.voteAverage,
  };

  String get subtitle => switch (this) {
    MovieMediaItem(:final movie) => movie.releaseDate,
    TvShowMediaItem(:final tvShow) => tvShow.firstAirDate,
  };

  String get overview => switch (this) {
    MovieMediaItem(:final movie) => movie.overview,
    TvShowMediaItem(:final tvShow) => tvShow.overview,
  };
}
