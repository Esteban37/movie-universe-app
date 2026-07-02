import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_multi_result_dto.freezed.dart';
part 'search_multi_result_dto.g.dart';

@freezed
sealed class SearchMultiResultDTO with _$SearchMultiResultDTO {
  const factory SearchMultiResultDTO({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'results') required List<TmdbMultiSearchItemDto> results,
  }) = _SearchMultiResultDTO;

  factory SearchMultiResultDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchMultiResultDTOFromJson(json);
}

@freezed
sealed class TmdbMultiSearchItemDto with _$TmdbMultiSearchItemDto {
  const factory TmdbMultiSearchItemDto({
    @JsonKey(name: 'media_type') required String mediaType,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @JsonKey(name: 'overview') String? overview,
  }) = _TmdbMultiSearchItemDto;

  factory TmdbMultiSearchItemDto.fromJson(Map<String, dynamic> json) =>
      _$TmdbMultiSearchItemDtoFromJson(json);
}
