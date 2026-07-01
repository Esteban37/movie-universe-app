import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';

class SearchMovies {
  SearchMovies(this._repository);

  final SearchRepository _repository;

  Future<SearchResultEntity> call(String query, {int page = 1}) {
    return _repository.searchMovies(query, page: page);
  }
}
