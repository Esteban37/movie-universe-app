import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_universe_app/features/search/domain/repositories/search_repository.dart';
import 'package:movie_universe_app/features/search/domain/usecases/search_media.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_repository_provider.dart';
import 'package:movie_universe_app/features/search/presentation/providers/search_usecase_providers.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWith((ref) => mockRepository),
      ],
    );
  }

  group('search use case providers', () {
    test('searchMediaProvider exposes SearchMedia wired to repository', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final useCase = container.read(searchMediaProvider);
      expect(useCase, isA<SearchMedia>());
    });
  });
}
