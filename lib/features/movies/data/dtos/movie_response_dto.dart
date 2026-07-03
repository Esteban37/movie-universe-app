import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_movie_dto.dart';

part 'movie_response_dto.freezed.dart';
part 'movie_response_dto.g.dart';

@freezed
sealed class MovieResponseDTO with _$MovieResponseDTO {
  const factory MovieResponseDTO({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'results') required List<TmdbMovieDto> results,
  }) = _MovieResponseDTO;

  factory MovieResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseDTOFromJson(json);
}
