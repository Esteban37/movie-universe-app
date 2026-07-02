import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_show_detail_entity.freezed.dart';

@freezed
sealed class TvShowDetailEntity with _$TvShowDetailEntity {
  const factory TvShowDetailEntity({
    required int id,
    required String name,
    required String posterPath,
    required double voteAverage,
    required String firstAirDate,
    required String overview,
    required String? backdropPath,
    required List<TvGenre> genres,
    required String tagline,
    required int numberOfSeasons,
    required int numberOfEpisodes,
    required String status,
    required List<String> networks,
  }) = _TvShowDetailEntity;
}

@freezed
sealed class TvGenre with _$TvGenre {
  const factory TvGenre({required int id, required String name}) = _TvGenre;
}
