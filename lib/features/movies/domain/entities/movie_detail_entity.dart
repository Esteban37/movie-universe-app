import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_entity.freezed.dart';

@freezed
sealed class MovieDetailEntity with _$MovieDetailEntity {
  const factory MovieDetailEntity({
    required int id,
    required String title,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
    required String overview,
    required String? backdropPath,
    required List<Genre> genres,
    required int runtime,
    required String tagline,
  }) = _MovieDetailEntity;
}

@freezed
sealed class Genre with _$Genre {
  const factory Genre({required int id, required String name}) = _Genre;
}
