import 'package:movie_universe_app/core/data/dtos/tmdb_movie_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_detail_dto.dart';
import 'package:movie_universe_app/features/movies/data/dtos/movie_response_dto.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/data/dtos/search_result_dto.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';

class TestFixtures {
  TestFixtures._();

  static const movieJson = <String, dynamic>{
    'id': 1,
    'title': 'Test Movie',
    'poster_path': '/poster.jpg',
    'vote_average': 7.5,
    'release_date': '2024-01-01',
    'overview': 'A test overview',
  };

  static const movieDetailJson = <String, dynamic>{
    'id': 1,
    'title': 'Test Movie',
    'poster_path': '/poster.jpg',
    'vote_average': 7.5,
    'release_date': '2024-01-01',
    'overview': 'A test overview',
    'backdrop_path': '/backdrop.jpg',
    'genres': [
      {'id': 28, 'name': 'Action'},
      {'id': 12, 'name': 'Adventure'},
    ],
    'runtime': 120,
    'tagline': 'A test tagline',
  };

  static const movieResponseJson = <String, dynamic>{
    'page': 1,
    'total_pages': 10,
    'results': [
      {
        'id': 1,
        'title': 'Test Movie',
        'poster_path': '/poster.jpg',
        'vote_average': 7.5,
        'release_date': '2024-01-01',
        'overview': 'A test overview',
      },
    ],
  };

  static const searchResultJson = <String, dynamic>{
    'page': 1,
    'total_pages': 5,
    'results': [
      {
        'id': 1,
        'title': 'Test Movie',
        'poster_path': '/poster.jpg',
        'vote_average': 7.5,
        'release_date': '2024-01-01',
        'overview': 'A test overview',
      },
    ],
  };

  static TmdbMovieDto createTmdbMovieDto({
    int id = 1,
    String title = 'Test Movie',
    String? posterPath = '/poster.jpg',
    double voteAverage = 7.5,
    String? releaseDate = '2024-01-01',
    String? overview = 'A test overview',
  }) {
    return TmdbMovieDto(
      id: id,
      title: title,
      posterPath: posterPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      overview: overview,
    );
  }

  static MovieDetailDTO createMovieDetailDTO({
    int id = 1,
    String title = 'Test Movie',
    String? posterPath = '/poster.jpg',
    double voteAverage = 7.5,
    String? releaseDate = '2024-01-01',
    String? overview = 'A test overview',
    String? backdropPath = '/backdrop.jpg',
    List<GenreDTO> genres = const [
      GenreDTO(id: 28, name: 'Action'),
      GenreDTO(id: 12, name: 'Adventure'),
    ],
    int runtime = 120,
    String tagline = 'A test tagline',
  }) {
    return MovieDetailDTO(
      id: id,
      title: title,
      posterPath: posterPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      overview: overview,
      backdropPath: backdropPath,
      genres: genres,
      runtime: runtime,
      tagline: tagline,
    );
  }

  static MovieResponseDTO createMovieResponseDTO({
    int page = 1,
    int totalPages = 10,
    List<TmdbMovieDto> results = const [],
  }) {
    return MovieResponseDTO(
      page: page,
      totalPages: totalPages,
      results: results,
    );
  }

  static SearchResultDTO createSearchResultDTO({
    int page = 1,
    int totalPages = 5,
    List<TmdbMovieDto> results = const [],
  }) {
    return SearchResultDTO(
      page: page,
      totalPages: totalPages,
      results: results,
    );
  }

  static MovieEntity createMovieEntity() => const MovieEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: '/poster.jpg',
    voteAverage: 7.5,
    releaseDate: '2024-01-01',
    overview: 'A test overview',
  );

  static MovieDetailEntity createMovieDetailEntity() => const MovieDetailEntity(
    id: 1,
    title: 'Test Movie',
    posterPath: '/poster.jpg',
    voteAverage: 7.5,
    releaseDate: '2024-01-01',
    overview: 'A test overview',
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 28, name: 'Action')],
    runtime: 120,
    tagline: 'A test tagline',
  );

  static SearchResultEntity createSearchResultEntity() =>
      const SearchResultEntity(page: 1, totalPages: 5, results: []);

  static List<MovieEntity> createMovieEntityList({int count = 2}) {
    return List.generate(
      count,
      (i) => MovieEntity(
        id: i + 1,
        title: 'Movie ${i + 1}',
        posterPath: '/poster${i + 1}.jpg',
        voteAverage: 7.0 + i * 0.5,
        releaseDate: '2024-01-${(i + 1).toString().padLeft(2, '0')}',
        overview: 'Overview ${i + 1}',
      ),
    );
  }
}
