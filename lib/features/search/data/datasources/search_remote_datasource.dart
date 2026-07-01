import 'package:dio/dio.dart';
import 'package:movie_universe_app/core/network/api_constants.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_result_dto.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SearchResultDTO> search(String query, {int page = 1}) async {
    final response = await _dio.get(
      ApiConstants.searchMovie,
      queryParameters: {
        'query': query,
        'page': page,
      },
    );
    return SearchResultDTO.fromJson(response.data);
  }
}
