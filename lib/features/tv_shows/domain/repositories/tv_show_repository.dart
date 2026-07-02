import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';

abstract class TvShowRepository {
  Future<List<TvShowEntity>> getPopular({int page = 1});
  Future<List<TvShowEntity>> getTopRated({int page = 1});
  Future<TvShowDetailEntity> getTvShowDetails(int tvShowId);
}
