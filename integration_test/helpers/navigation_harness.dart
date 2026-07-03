import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart';
import 'package:movie_universe_app/core/router/app_router.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';
import 'package:movie_universe_app/shared/domain/entities/media_item.dart';
import 'package:movie_universe_app/shared/presentation/shell/app_shell.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockTvShowRepository extends Mock implements TvShowRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

const popularMovies = [
  MovieEntity(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    voteAverage: 8.8,
    releaseDate: '2010-07-16',
    overview: 'A thief who steals corporate secrets.',
  ),
];

const movieDetail = MovieDetailEntity(
  id: 1,
  title: 'Inception',
  posterPath: '/poster.jpg',
  voteAverage: 8.8,
  releaseDate: '2010-07-16',
  overview: 'A thief who steals corporate secrets.',
  backdropPath: '/backdrop.jpg',
  genres: [Genre(id: 28, name: 'Action')],
  runtime: 148,
  tagline: 'Your mind is the scene of the crime.',
);

const popularTvShows = [
  TvShowEntity(
    id: 2,
    name: 'Breaking Bad',
    posterPath: '/bb.jpg',
    voteAverage: 9.5,
    firstAirDate: '2008-01-20',
    overview: 'A chemistry teacher turned meth producer.',
  ),
];

const tvShowDetail = TvShowDetailEntity(
  id: 2,
  name: 'Breaking Bad',
  posterPath: '/bb.jpg',
  voteAverage: 9.5,
  firstAirDate: '2008-01-20',
  overview: 'A chemistry teacher turned meth producer.',
  backdropPath: '/backdrop.jpg',
  genres: [TvGenre(id: 18, name: 'Drama')],
  tagline: 'All bad things...',
  numberOfSeasons: 5,
  numberOfEpisodes: 62,
  status: 'Ended',
  networks: ['AMC'],
);

const searchMovieDetail = MovieDetailEntity(
  id: 3,
  title: 'The Dark Knight',
  posterPath: '/tdk.jpg',
  voteAverage: 9.0,
  releaseDate: '2008-07-18',
  overview: 'Batman faces the Joker.',
  backdropPath: '/backdrop.jpg',
  genres: [Genre(id: 28, name: 'Action')],
  runtime: 152,
  tagline: 'Why so serious?',
);

final searchResults = const SearchResultEntity(
  results: [
    MediaItem.movie(
      MovieEntity(
        id: 3,
        title: 'The Dark Knight',
        posterPath: '/tdk.jpg',
        voteAverage: 9.0,
        releaseDate: '2008-07-18',
        overview: 'Batman faces the Joker.',
      ),
    ),
  ],
  page: 1,
  totalPages: 1,
);

/// Offline repository mocks for end-to-end navigation tests (no TMDB network).
List<Override> navigationTestOverrides({
  MockMovieRepository? movieRepository,
  MockTvShowRepository? tvShowRepository,
  MockSearchRepository? searchRepository,
}) {
  final movies = movieRepository ?? MockMovieRepository();
  final tvShows = tvShowRepository ?? MockTvShowRepository();
  final search = searchRepository ?? MockSearchRepository();

  when(
    () => movies.getPopular(page: any(named: 'page')),
  ).thenAnswer((_) async => popularMovies);
  when(
    () => movies.getTopRated(page: any(named: 'page')),
  ).thenAnswer((_) async => const <MovieEntity>[]);
  when(() => movies.getMovieDetails(1)).thenAnswer((_) async => movieDetail);
  when(() => movies.getMovieDetails(3)).thenAnswer((_) async => searchMovieDetail);

  when(
    () => tvShows.getPopular(page: any(named: 'page')),
  ).thenAnswer((_) async => popularTvShows);
  when(
    () => tvShows.getTopRated(page: any(named: 'page')),
  ).thenAnswer((_) async => const <TvShowEntity>[]);
  when(() => tvShows.getTvShowDetails(2)).thenAnswer((_) async => tvShowDetail);

  when(
    () => search.searchMedia(any(), page: any(named: 'page')),
  ).thenAnswer((invocation) async {
    final query = invocation.positionalArguments.first as String;
    if (query.trim().isEmpty) {
      return const SearchResultEntity(
        results: [],
        page: 1,
        totalPages: 0,
      );
    }
    return searchResults;
  });

  return [
    movieRepositoryProvider.overrideWith((ref) => movies),
    tvShowRepositoryProvider.overrideWith((ref) => tvShows),
    searchRepositoryProvider.overrideWith((ref) => search),
  ];
}

Future<void> pumpNavigationApp(WidgetTester tester) async {
  dotenv.loadFromString(envString: 'TMDB_ACCESS_TOKEN=integration-test-token');
  AppRouter.defineRoutes();

  await tester.pumpWidget(
    ProviderScope(
      overrides: navigationTestOverrides(),
      child: MaterialApp(
        onGenerateRoute: FluroRouter.appRouter.generator,
        home: const AppShell(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> selectShellTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}
