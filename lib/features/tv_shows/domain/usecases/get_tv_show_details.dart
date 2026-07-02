import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';

class GetTvShowDetails {
  GetTvShowDetails(this._repository);

  final TvShowRepository _repository;

  Future<TvShowDetailEntity> call(int tvShowId) {
    return _repository.getTvShowDetails(tvShowId);
  }
}
