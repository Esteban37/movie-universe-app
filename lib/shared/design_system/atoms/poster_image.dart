import 'package:flutter/material.dart';

import '../../../core/media/tmdb_image.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.size = TmdbPosterSize.medium,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
    this.placeholderIconSize = 48,
  });

  final String? path;
  final double width;
  final double height;
  final TmdbPosterSize size;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final double placeholderIconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = TmdbImageUrl.poster(path, size: size);
    final placeholder = Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie,
        size: placeholderIconSize,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    if (url == null) {
      return ClipRRect(borderRadius: borderRadius, child: placeholder);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
