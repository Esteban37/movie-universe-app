import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_dto.freezed.dart';
part 'movie_detail_dto.g.dart';

@freezed
sealed class MovieDetailDTO with _$MovieDetailDTO {
  const factory MovieDetailDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String? releaseDate,
    @JsonKey(name: 'overview') required String? overview,
    @JsonKey(name: 'backdrop_path') required String? backdropPath,
    @JsonKey(name: 'genres') required List<GenreDTO> genres,
    @JsonKey(name: 'runtime') required int runtime,
    @JsonKey(name: 'tagline') required String tagline,
  }) = _MovieDetailDTO;

  factory MovieDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailDTOFromJson(json);
}

@freezed
sealed class GenreDTO with _$GenreDTO {
  const factory GenreDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _GenreDTO;

  factory GenreDTO.fromJson(Map<String, dynamic> json) =>
      _$GenreDTOFromJson(json);
}
