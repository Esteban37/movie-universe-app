import 'package:dio/dio.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_response_dto.dart';

class MovieRemoteDataSource {
  MovieRemoteDataSource(this._dio);

  final Dio _dio;

  Future<MovieResponseDTO> getPopular({int page = 1}) async {
    final response = await _dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return MovieResponseDTO.fromJson(response.data);
  }

  Future<MovieResponseDTO> getTopRated({int page = 1}) async {
    final response = await _dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );
    return MovieResponseDTO.fromJson(response.data);
  }

  Future<MovieDetailDTO> getMovieDetails(int movieId) async {
    final response = await _dio.get('/movie/$movieId');
    return MovieDetailDTO.fromJson(response.data);
  }
}
