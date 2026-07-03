import '../config/app_environment.dart';

/// Semantic TMDB poster sizes mapped to official size segments.
enum TmdbPosterSize {
  /// Thumbnail (list leading) — `w92`
  small,

  /// Grid card — `w500`
  medium,

  /// Detail hero poster — `w342`
  large,
}

/// Builds fully-qualified TMDB image URLs from path segments.
class TmdbImageUrl {
  const TmdbImageUrl([this.baseUrl = EnvironmentConfig.defaultImageBaseUrl]);

  final String baseUrl;

  /// Returns a poster URL or `null` when [path] is null/empty.
  String? poster(String? path, {TmdbPosterSize size = TmdbPosterSize.medium}) {
    if (path == null || path.isEmpty) {
      return null;
    }
    final segment = switch (size) {
      TmdbPosterSize.small => 'w92',
      TmdbPosterSize.medium => 'w500',
      TmdbPosterSize.large => 'w342',
    };
    return '$baseUrl$segment$path';
  }

  /// Returns a backdrop URL or `null` when [path] is null/empty.
  String? backdrop(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }
    return '${baseUrl}w780$path';
  }
}
