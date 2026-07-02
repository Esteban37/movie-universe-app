import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmdb_movie_dto.freezed.dart';
part 'tmdb_movie_dto.g.dart';

/// Shared TMDB movie list-item payload used by multiple features.
@freezed
sealed class TmdbMovieDto with _$TmdbMovieDto {
  const factory TmdbMovieDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String? releaseDate,
    @JsonKey(name: 'overview') required String? overview,
  }) = _TmdbMovieDto;

  factory TmdbMovieDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbMovieDtoFromJson(json);
}
