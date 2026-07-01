import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getPopular({int page = 1});
  Future<List<MovieEntity>> getTopRated({int page = 1});
  Future<MovieDetailEntity> getMovieDetails(int movieId);
}
