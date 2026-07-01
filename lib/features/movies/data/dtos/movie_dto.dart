import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_dto.freezed.dart';
part 'movie_dto.g.dart';

@freezed
sealed class MovieDTO with _$MovieDTO {
  const factory MovieDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String? releaseDate,
    @JsonKey(name: 'overview') required String? overview,
  }) = _MovieDTO;

  factory MovieDTO.fromJson(Map<String, dynamic> json) => _$MovieDTOFromJson(json);
}
