import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/media/tmdb_image.dart';

void main() {
  group('TmdbImageUrl', () {
    const imageUrls = TmdbImageUrl();

    test('builds poster URLs for each size segment', () {
      const path = '/poster.jpg';

      expect(
        imageUrls.poster(path, size: TmdbPosterSize.small),
        'https://image.tmdb.org/t/p/w92/poster.jpg',
      );
      expect(
        imageUrls.poster(path, size: TmdbPosterSize.medium),
        'https://image.tmdb.org/t/p/w500/poster.jpg',
      );
      expect(
        imageUrls.poster(path, size: TmdbPosterSize.large),
        'https://image.tmdb.org/t/p/w342/poster.jpg',
      );
    });

    test('builds backdrop URL', () {
      expect(
        imageUrls.backdrop('/backdrop.jpg'),
        'https://image.tmdb.org/t/p/w780/backdrop.jpg',
      );
    });

    test('uses custom base URL when provided', () {
      const custom = TmdbImageUrl('https://cdn.example/');
      expect(
        custom.poster('/poster.jpg'),
        'https://cdn.example/w500/poster.jpg',
      );
    });

    test('returns null for empty poster path', () {
      expect(imageUrls.poster(null), isNull);
      expect(imageUrls.poster(''), isNull);
    });

    test('returns null for empty backdrop path', () {
      expect(imageUrls.backdrop(null), isNull);
      expect(imageUrls.backdrop(''), isNull);
    });
  });
}
