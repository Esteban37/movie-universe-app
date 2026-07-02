import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/core/domain/entities/media_item.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/features/search/domain/entities/search_result_entity.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;
  late SearchMedia useCase;

  setUp(() {
    mockRepository = MockSearchRepository();
    useCase = SearchMedia(mockRepository);
  });

  test('calls repository.searchMedia with provided query and page', () async {
    when(
      () => mockRepository.searchMedia('test', page: 2),
    ).thenAnswer(
      (_) async => const SearchResultEntity(page: 2, totalPages: 5, results: []),
    );

    final result = await useCase('test', page: 2);

    expect(result.page, 2);
    verify(() => mockRepository.searchMedia('test', page: 2)).called(1);
  });

  test('returns empty result for blank query without calling repository', () async {
    final result = await useCase('   ');

    expect(result.results, isEmpty);
    expect(result.totalPages, 0);
    verifyNever(() => mockRepository.searchMedia(any(), page: any(named: 'page')));
  });

  test('trims query before calling repository', () async {
    when(
      () => mockRepository.searchMedia('test', page: 1),
    ).thenAnswer(
      (_) async => SearchResultEntity(
        page: 1,
        totalPages: 1,
        results: [
          MediaItem.movie(
            const MovieEntity(
              id: 1,
              title: 'Test',
              posterPath: '/poster.jpg',
              voteAverage: 7.5,
              releaseDate: '2024-01-01',
              overview: 'Overview',
            ),
          ),
        ],
      ),
    );

    final result = await useCase('  test  ');

    expect(result.results.length, 1);
    verify(() => mockRepository.searchMedia('test', page: 1)).called(1);
  });
}
