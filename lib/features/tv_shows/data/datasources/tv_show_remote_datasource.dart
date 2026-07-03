import 'package:dio/dio.dart';
import 'package:movie_universe_app/features/tv_shows/data/dtos/tv_show_detail_dto.dart';
import 'package:movie_universe_app/features/tv_shows/data/dtos/tv_show_response_dto.dart';

class TvShowRemoteDataSource {
  TvShowRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TvShowResponseDTO> getPopular({int page = 1}) async {
    final response = await _dio.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );
    return TvShowResponseDTO.fromJson(response.data);
  }

  Future<TvShowResponseDTO> getTopRated({int page = 1}) async {
    final response = await _dio.get(
      '/tv/top_rated',
      queryParameters: {'page': page},
    );
    return TvShowResponseDTO.fromJson(response.data);
  }

  Future<TvShowDetailDTO> getTvShowDetails(int tvShowId) async {
    final response = await _dio.get('/tv/$tvShowId');
    return TvShowDetailDTO.fromJson(response.data);
  }
}
