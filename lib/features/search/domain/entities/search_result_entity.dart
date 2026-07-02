import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';

part 'search_result_entity.freezed.dart';

@freezed
sealed class SearchResultEntity with _$SearchResultEntity {
  const factory SearchResultEntity({
    required int page,
    required List<MediaItem> results,
    required int totalPages,
  }) = _SearchResultEntity;
}
