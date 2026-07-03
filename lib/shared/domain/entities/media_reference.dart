import 'media_type.dart';

/// Stable cross-feature identity for navigation and deep links without loading
/// a full domain entity.
class MediaReference {
  const MediaReference({
    required this.id,
    required this.type,
  });

  final int id;
  final MediaType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaReference && other.id == id && other.type == type;

  @override
  int get hashCode => Object.hash(id, type);
}
