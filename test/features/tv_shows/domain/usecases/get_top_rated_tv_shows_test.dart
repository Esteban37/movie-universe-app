import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_top_rated_tv_shows.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

void main() {
  late MockTvShowRepository mockRepository;
  late GetTopRatedTvShows useCase;

  setUp(() {
    mockRepository = MockTvShowRepository();
    useCase = GetTopRatedTvShows(mockRepository);
  });

  test('calls repository.getTopRated with provided page', () async {
    when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
      (_) async => [
        const TvShowEntity(
          id: 2,
          name: 'Top Rated Show',
          posterPath: '/poster2.jpg',
          voteAverage: 8.0,
          firstAirDate: '2024-02-01',
          overview: 'Great show',
        ),
      ],
    );

    final result = await useCase(page: 1);

    expect(result.length, 1);
    verify(() => mockRepository.getTopRated(page: 1)).called(1);
  });
}
