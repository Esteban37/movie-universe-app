import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_movies.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

class MockSearchMovies extends Mock implements SearchMovies {}

ProviderContainer createMovieRepositoryContainer(MovieRepository repository) {
  return ProviderContainer(
    overrides: [movieRepositoryProvider.overrideWith((ref) => repository)],
  );
}

ProviderContainer createSearchRepositoryContainer(
  SearchRepository repository,
) {
  return ProviderContainer(
    overrides: [searchRepositoryProvider.overrideWith((ref) => repository)],
  );
}

ProviderContainer createSearchMoviesContainer(SearchMovies searchMovies) {
  return ProviderContainer(
    overrides: [searchMoviesProvider.overrideWith((ref) => searchMovies)],
  );
}
