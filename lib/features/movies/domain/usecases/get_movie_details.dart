import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  GetMovieDetails(this._repository);

  final MovieRepository _repository;

  Future<MovieDetailEntity> call(int movieId) {
    return _repository.getMovieDetails(movieId);
  }
}
