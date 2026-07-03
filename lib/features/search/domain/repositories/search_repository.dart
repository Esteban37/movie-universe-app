import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<SearchResultEntity> searchMedia(String query, {int page = 1});
}
