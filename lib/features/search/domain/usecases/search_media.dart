import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';

class SearchMedia {
  SearchMedia(this._repository);

  final SearchRepository _repository;

  Future<SearchResultEntity> call(String query, {int page = 1}) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const SearchResultEntity(page: 1, totalPages: 0, results: []),
      );
    }
    return _repository.searchMedia(trimmed, page: page);
  }
}
