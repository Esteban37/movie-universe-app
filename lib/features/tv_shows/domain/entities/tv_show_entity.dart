import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_show_entity.freezed.dart';

@freezed
sealed class TvShowEntity with _$TvShowEntity {
  const factory TvShowEntity({
    required int id,
    required String name,
    required String posterPath,
    required double voteAverage,
    required String firstAirDate,
    required String overview,
  }) = _TvShowEntity;
}
