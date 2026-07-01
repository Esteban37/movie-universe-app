import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_movies.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;
  late SearchMovies useCase;

  setUp(() {
    mockRepository = MockSearchRepository();
    useCase = SearchMovies(mockRepository);
  });

  test('calls repository.searchMovies with provided query and page', () async {
    when(() => mockRepository.searchMovies('test', page: 1)).thenAnswer(
      (_) async => const SearchResultEntity(
        page: 1,
        results: [],
        totalPages: 1,
      ),
    );

    final result = await useCase('test', page: 1);

    expect(result, isA<SearchResultEntity>());
    verify(() => mockRepository.searchMovies('test', page: 1)).called(1);
  });

  test('uses default page 1 when page is omitted', () async {
    when(() => mockRepository.searchMovies('test', page: 1)).thenAnswer(
      (_) async => SearchResultEntity(
        page: 1,
        results: [
          MovieEntity(
            id: 1,
            title: 'Test',
            posterPath: '/poster.jpg',
            voteAverage: 7.5,
            releaseDate: '2024-01-01',
            overview: 'Overview',
          ),
        ],
        totalPages: 1,
      ),
    );

    final result = await useCase('test');

    expect(result.results.length, 1);
    verify(() => mockRepository.searchMovies('test', page: 1)).called(1);
  });
}
