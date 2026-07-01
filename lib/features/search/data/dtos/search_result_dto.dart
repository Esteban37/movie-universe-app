import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_dto.dart';

part 'search_result_dto.freezed.dart';
part 'search_result_dto.g.dart';

@freezed
sealed class SearchResultDTO with _$SearchResultDTO {
  const factory SearchResultDTO({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'results') required List<MovieDTO> results,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _SearchResultDTO;

  factory SearchResultDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchResultDTOFromJson(json);
}
