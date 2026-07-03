/// TMDB media kinds supported by unified search and navigation today.
///
/// When adding catalog types (e.g. person, collection), extend this enum and
/// [MediaItem] in the same change set so switches stay exhaustive.
enum MediaType {
  movie,
  tvShow,
}
