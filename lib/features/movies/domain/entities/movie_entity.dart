import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_entity.freezed.dart';

@freezed
sealed class MovieEntity with _$MovieEntity {
  const factory MovieEntity({
    required int id,
    required String title,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
    required String overview,
  }) = _MovieEntity;
}
