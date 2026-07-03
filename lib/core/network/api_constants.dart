class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String moviePopular = '/movie/popular';
  static const String movieTopRated = '/movie/top_rated';
  static const String movieDetails = '/movie';
  static const String searchMovie = '/search/movie';
}
