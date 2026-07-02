import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_universe_app/shared/design_system/models/movie_display_model.dart';
import 'package:movie_universe_app/shared/mappers/movie_display_mapper.dart';

void main() {
  test('toMovieDisplayModel maps entity fields', () {
    const entity = MovieEntity(
      id: 1,
      title: 'Inception',
      posterPath: '/poster.jpg',
      voteAverage: 8.8,
      releaseDate: '2010-07-16',
      overview: 'Overview',
    );

    final model = toMovieDisplayModel(entity);

    expect(model, isA<MovieDisplayModel>());
    expect(model.id, 1);
    expect(model.title, 'Inception');
    expect(model.posterPath, '/poster.jpg');
    expect(model.voteAverage, 8.8);
    expect(model.releaseDate, '2010-07-16');
  });
}
