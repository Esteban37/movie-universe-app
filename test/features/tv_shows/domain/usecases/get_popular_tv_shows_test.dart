import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_popular_tv_shows.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

void main() {
  late MockTvShowRepository mockRepository;
  late GetPopularTvShows useCase;

  setUp(() {
    mockRepository = MockTvShowRepository();
    useCase = GetPopularTvShows(mockRepository);
  });

  test('calls repository.getPopular with provided page', () async {
    when(() => mockRepository.getPopular(page: 1)).thenAnswer(
      (_) async => [
        const TvShowEntity(
          id: 1,
          name: 'Test Show',
          posterPath: '/poster.jpg',
          voteAverage: 7.5,
          firstAirDate: '2024-01-01',
          overview: 'Overview',
        ),
      ],
    );

    final result = await useCase(page: 1);

    expect(result.length, 1);
    verify(() => mockRepository.getPopular(page: 1)).called(1);
  });
}
