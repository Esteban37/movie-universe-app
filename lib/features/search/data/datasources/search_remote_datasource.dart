import 'package:dio/dio.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_multi_result_dto.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SearchMultiResultDTO> searchMulti(String query, {int page = 1}) async {
    final response = await _dio.get(
      '/search/multi',
      queryParameters: {'query': query, 'page': page},
    );
    return SearchMultiResultDTO.fromJson(response.data);
  }
}
