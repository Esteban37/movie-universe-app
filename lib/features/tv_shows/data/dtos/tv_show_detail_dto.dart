import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_show_detail_dto.freezed.dart';
part 'tv_show_detail_dto.g.dart';

@freezed
sealed class TvShowDetailDTO with _$TvShowDetailDTO {
  const factory TvShowDetailDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'first_air_date') required String? firstAirDate,
    @JsonKey(name: 'overview') required String? overview,
    @JsonKey(name: 'backdrop_path') required String? backdropPath,
    @JsonKey(name: 'genres') required List<TvGenreDTO> genres,
    @JsonKey(name: 'tagline') required String tagline,
    @JsonKey(name: 'number_of_seasons') required int numberOfSeasons,
    @JsonKey(name: 'number_of_episodes') required int numberOfEpisodes,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'networks') required List<TvNetworkDTO> networks,
  }) = _TvShowDetailDTO;

  factory TvShowDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$TvShowDetailDTOFromJson(json);
}

@freezed
sealed class TvGenreDTO with _$TvGenreDTO {
  const factory TvGenreDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _TvGenreDTO;

  factory TvGenreDTO.fromJson(Map<String, dynamic> json) =>
      _$TvGenreDTOFromJson(json);
}

@freezed
sealed class TvNetworkDTO with _$TvNetworkDTO {
  const factory TvNetworkDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _TvNetworkDTO;

  factory TvNetworkDTO.fromJson(Map<String, dynamic> json) =>
      _$TvNetworkDTOFromJson(json);
}
