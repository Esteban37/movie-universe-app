/// Where a [MediaCard] is shown — drives presentation such as the media-type badge.
enum MediaCardLayout {
  /// Dedicated movies or TV tabs; media type is already implied by the section.
  section,

  /// Mixed search results; show a movie/TV badge on the poster.
  search,
}
