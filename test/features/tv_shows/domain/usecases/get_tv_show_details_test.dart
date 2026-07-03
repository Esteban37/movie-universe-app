import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/tv_shows/domain/entities/tv_show_detail_entity.dart';
import 'package:movie_universe_app/features/tv_shows/domain/repositories/tv_show_repository.dart';
import 'package:movie_universe_app/features/tv_shows/domain/usecases/get_tv_show_details.dart';

class MockTvShowRepository extends Mock implements TvShowRepository {}

const _testDetail = TvShowDetailEntity(
  id: 42,
  name: 'The Wire',
  posterPath: '/poster.jpg',
  voteAverage: 9.3,
  firstAirDate: '2002-06-02',
  overview: 'Baltimore drug scene.',
  backdropPath: '/backdrop.jpg',
  genres: [TvGenre(id: 18, name: 'Crime')],
  tagline: 'Listen carefully',
  numberOfSeasons: 5,
  numberOfEpisodes: 60,
  status: 'Ended',
  networks: ['HBO'],
);

void main() {
  late MockTvShowRepository mockRepository;
  late GetTvShowDetails useCase;

  setUp(() {
    mockRepository = MockTvShowRepository();
    useCase = GetTvShowDetails(mockRepository);
  });

  test('calls repository.getTvShowDetails with provided id', () async {
    when(
      () => mockRepository.getTvShowDetails(42),
    ).thenAnswer((_) async => _testDetail);

    final result = await useCase(42);

    expect(result.name, 'The Wire');
    verify(() => mockRepository.getTvShowDetails(42)).called(1);
  });
}
