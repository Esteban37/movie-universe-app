import 'package:fluro/fluro.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/router/app_router.dart';

void main() {
  group('AppRouter', () {
    setUp(() {
      AppRouter.defineRoutes();
    });

    test('registers home route', () {
      final match = FluroRouter.appRouter.match('/');

      expect(match, isNotNull);
    });

    test('registers movie detail route', () {
      final match = FluroRouter.appRouter.match('/movie/123');

      expect(match, isNotNull);
    });

    test('extracts movie ID from route parameters', () {
      final match = FluroRouter.appRouter.match('/movie/123');

      expect(match, isNotNull);
      expect(match!.parameters['id'], ['123']);
    });

    test('registers search route', () {
      final match = FluroRouter.appRouter.match('/search');

      expect(match, isNotNull);
    });
  });
}
