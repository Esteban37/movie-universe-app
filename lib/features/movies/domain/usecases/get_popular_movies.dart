import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  GetPopularMovies(this._repository);

  final MovieRepository _repository;

  Future<List<MovieEntity>> call({int page = 1}) {
    return _repository.getPopular(page: page);
  }
}
