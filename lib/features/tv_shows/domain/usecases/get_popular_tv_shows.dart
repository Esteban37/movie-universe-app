import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';

class GetPopularTvShows {
  GetPopularTvShows(this._repository);

  final TvShowRepository _repository;

  Future<List<TvShowEntity>> call({int page = 1}) {
    return _repository.getPopular(page: page);
  }
}
