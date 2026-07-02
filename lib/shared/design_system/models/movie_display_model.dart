/// Feature-agnostic movie card/list display data for the design system.
class MovieDisplayModel {
  const MovieDisplayModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    this.releaseDate = '',
  });

  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
}
