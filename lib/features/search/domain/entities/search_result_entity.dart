import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

part 'search_result_entity.freezed.dart';

@freezed
sealed class SearchResultEntity with _$SearchResultEntity {
  const factory SearchResultEntity({
    required int page,
    required List<MovieEntity> results,
    required int totalPages,
  }) = _SearchResultEntity;
}
