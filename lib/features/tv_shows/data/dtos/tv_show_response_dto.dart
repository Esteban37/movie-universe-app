import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/core/data/dtos/tmdb_tv_show_dto.dart';

part 'tv_show_response_dto.freezed.dart';
part 'tv_show_response_dto.g.dart';

@freezed
sealed class TvShowResponseDTO with _$TvShowResponseDTO {
  const factory TvShowResponseDTO({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'results') required List<TmdbTvShowDto> results,
  }) = _TvShowResponseDTO;

  factory TvShowResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$TvShowResponseDTOFromJson(json);
}
