import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_detail_entity.dart';
import 'package:movie_universe_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_universe_app/features/movies/domain/usecases/get_movie_details.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late GetMovieDetails useCase;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetMovieDetails(mockRepository);
  });

  test('calls repository.getMovieDetails with provided id', () async {
    when(() => mockRepository.getMovieDetails(1)).thenAnswer(
      (_) async => const MovieDetailEntity(
        id: 1,
        title: 'Detail Movie',
        posterPath: '/poster.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
        overview: 'Overview',
        backdropPath: '/backdrop.jpg',
        genres: [],
        runtime: 120,
        tagline: 'Tagline',
      ),
    );

    final result = await useCase(1);

    expect(result.id, 1);
    verify(() => mockRepository.getMovieDetails(1)).called(1);
  });
}
