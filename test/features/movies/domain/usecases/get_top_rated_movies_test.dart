import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_top_rated_movies.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late GetTopRatedMovies useCase;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetTopRatedMovies(mockRepository);
  });

  test('calls repository.getTopRated with provided page', () async {
    when(() => mockRepository.getTopRated(page: 1)).thenAnswer(
      (_) async => [
        MovieEntity(
          id: 2,
          title: 'Top Rated',
          posterPath: '/poster2.jpg',
          voteAverage: 8.0,
          releaseDate: '2024-02-01',
          overview: 'Great movie',
        ),
      ],
    );

    final result = await useCase(page: 1);

    expect(result.length, 1);
    verify(() => mockRepository.getTopRated(page: 1)).called(1);
  });
}
