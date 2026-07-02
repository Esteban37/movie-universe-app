import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/media/tmdb_image.dart';

void main() {
  group('TmdbImageUrl', () {
    test('builds poster URLs for each size segment', () {
      const path = '/poster.jpg';

      expect(
        TmdbImageUrl.poster(path, size: TmdbPosterSize.small),
        'https://image.tmdb.org/t/p/w92/poster.jpg',
      );
      expect(
        TmdbImageUrl.poster(path, size: TmdbPosterSize.medium),
        'https://image.tmdb.org/t/p/w500/poster.jpg',
      );
      expect(
        TmdbImageUrl.poster(path, size: TmdbPosterSize.large),
        'https://image.tmdb.org/t/p/w342/poster.jpg',
      );
    });

    test('builds backdrop URL', () {
      expect(
        TmdbImageUrl.backdrop('/backdrop.jpg'),
        'https://image.tmdb.org/t/p/w780/backdrop.jpg',
      );
    });

    test('returns null for empty poster path', () {
      expect(TmdbImageUrl.poster(null), isNull);
      expect(TmdbImageUrl.poster(''), isNull);
    });

    test('returns null for empty backdrop path', () {
      expect(TmdbImageUrl.backdrop(null), isNull);
      expect(TmdbImageUrl.backdrop(''), isNull);
    });
  });
}
