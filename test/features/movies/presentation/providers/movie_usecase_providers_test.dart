import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_movie_details.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_usecase_providers.dart';

import '../../../../helpers/provider_container.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
  });

  ProviderContainer createContainer() {
    return createTestContainer(
      overrides: [
        movieRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  }

  group('movie use case providers', () {
    test(
      'getPopularMoviesProvider exposes GetPopularMovies wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getPopularMoviesProvider);
        expect(useCase, isA<GetPopularMovies>());
      },
    );

    test(
      'getTopRatedMoviesProvider exposes GetTopRatedMovies wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getTopRatedMoviesProvider);
        expect(useCase, isA<GetTopRatedMovies>());
      },
    );

    test(
      'getMovieDetailsProvider exposes GetMovieDetails wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getMovieDetailsProvider);
        expect(useCase, isA<GetMovieDetails>());
      },
    );
  });
}
