import 'package:movie_universe_app/shared/domain/entities/media_type.dart';

/// Feature-agnostic media card/list display data for the design system.
class MediaDisplayModel {
  const MediaDisplayModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.subtitle,
    required this.mediaType,
  });

  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String subtitle;
  final MediaType mediaType;
}
