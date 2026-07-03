import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_popular_tv_shows.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_tv_show_details.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_repository_provider.dart';
import 'package:movie_universe_app/features/tv_shows/presentation/providers/tv_show_usecase_providers.dart';

import '../../../../helpers/provider_container.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

void main() {
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
  });

  ProviderContainer createContainer() {
    return createTestContainer(
      overrides: [
        tvShowRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  }

  group('tv show use case providers', () {
    test(
      'getPopularTvShowsProvider exposes GetPopularTvShows wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getPopularTvShowsProvider);
        expect(useCase, isA<GetPopularTvShows>());
      },
    );

    test(
      'getTopRatedTvShowsProvider exposes GetTopRatedTvShows wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getTopRatedTvShowsProvider);
        expect(useCase, isA<GetTopRatedTvShows>());
      },
    );

    test(
      'getTvShowDetailsProvider exposes GetTvShowDetails wired to repository',
      () {
        final container = createContainer();

        final useCase = container.read(getTvShowDetailsProvider);
        expect(useCase, isA<GetTvShowDetails>());
      },
    );
  });
}
