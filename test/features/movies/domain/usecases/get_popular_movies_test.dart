import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_popular_movies.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late GetPopularMovies useCase;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetPopularMovies(mockRepository);
  });

  test('calls repository.getPopular with provided page', () async {
    when(() => mockRepository.getPopular(page: 1)).thenAnswer(
      (_) async => [
        const MovieEntity(
          id: 1,
          title: 'Test',
          posterPath: '/poster.jpg',
          voteAverage: 7.5,
          releaseDate: '2024-01-01',
          overview: 'Overview',
        ),
      ],
    );

    final result = await useCase(page: 1);

    expect(result.length, 1);
    verify(() => mockRepository.getPopular(page: 1)).called(1);
  });
}
