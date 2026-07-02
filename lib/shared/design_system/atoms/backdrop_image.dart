import 'package:flutter/material.dart';

import '../../../core/media/tmdb_image.dart';

class BackdropImage extends StatelessWidget {
  const BackdropImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    TmdbImageUrl? imageUrls,
  }) : imageUrls = imageUrls ?? const TmdbImageUrl();

  final String? path;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final TmdbImageUrl imageUrls;

  @override
  Widget build(BuildContext context) {
    final url = imageUrls.backdrop(path);
    if (url == null) {
      return SizedBox(width: width, height: height);
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (_, _, _) => SizedBox(width: width, height: height),
    );
  }
}
