import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

class MockTvShowRepository extends Mock implements TvShowRepository {}

/// Overrides list + TV repositories so widget tests never hit TMDB.
List<Override> offlineRepositoryOverrides() {
  final movieRepository = MockMovieRepository();
  final tvShowRepository = MockTvShowRepository();

  when(
    () => movieRepository.getPopular(page: any(named: 'page')),
  ).thenAnswer((_) async => []);
  when(
    () => movieRepository.getTopRated(page: any(named: 'page')),
  ).thenAnswer((_) async => []);
  when(
    () => tvShowRepository.getPopular(page: any(named: 'page')),
  ).thenAnswer((_) async => []);
  when(
    () => tvShowRepository.getTopRated(page: any(named: 'page')),
  ).thenAnswer((_) async => []);

  return [
    movieRepositoryProvider.overrideWith((ref) => movieRepository),
    tvShowRepositoryProvider.overrideWith((ref) => tvShowRepository),
  ];
}
