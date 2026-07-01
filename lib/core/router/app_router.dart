import 'package:fluro/fluro.dart';
import '../../features/movies/presentation/screens/movie_detail_screen.dart';
import '../../features/movies/presentation/screens/movie_list_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

class AppRouter {
  AppRouter._();

  static bool _routesDefined = false;

  static void defineRoutes() {
    if (_routesDefined) return;
    _routesDefined = true;

    FluroRouter.appRouter.define(
      '/',
      handler: Handler(handlerFunc: (_, _) => const MovieListScreen()),
    );

    FluroRouter.appRouter.define(
      '/movie/:id',
      handler: Handler(handlerFunc: (_, parameters) {
        final id = parameters['id']?.first ?? '';
        return MovieDetailScreen(movieId: id);
      }),
    );

    FluroRouter.appRouter.define(
      '/search',
      handler: Handler(handlerFunc: (_, _) => const SearchScreen()),
    );
  }
}
