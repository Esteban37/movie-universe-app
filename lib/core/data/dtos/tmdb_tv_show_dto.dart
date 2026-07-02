import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmdb_tv_show_dto.freezed.dart';
part 'tmdb_tv_show_dto.g.dart';

/// Shared TMDB TV list-item payload used by multiple features.
@freezed
sealed class TmdbTvShowDto with _$TmdbTvShowDto {
  const factory TmdbTvShowDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'first_air_date') required String? firstAirDate,
    @JsonKey(name: 'overview') required String? overview,
  }) = _TmdbTvShowDto;

  factory TmdbTvShowDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbTvShowDtoFromJson(json);
}
