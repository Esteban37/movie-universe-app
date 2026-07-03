import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../../features/movies/presentation/screens/movie_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/tv_shows/presentation/screens/tv_show_detail_screen.dart';
import '../../shared/presentation/shell/app_shell.dart';

class AppRouter {
  AppRouter._();

  static bool _routesDefined = false;

  /// Navigates to the immersive detail screen through Fluro on a **non-opaque**
  /// route (`opaque: false`) so the screen below stays painted. This lets the
  /// detail screen fade its own background out during the swipe-to-dismiss
  /// gesture and reveal the list underneath, instead of showing a black
  /// backdrop — all while keeping navigation centralized in Fluro.
  static Future<dynamic> pushMovieDetail(BuildContext context, String id) {
    return FluroRouter.appRouter.navigateTo(
      context,
      '/movie/$id',
      transition: TransitionType.custom,
      transitionDuration: const Duration(milliseconds: 300),
      opaque: false,
      transitionBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static Future<dynamic> pushTvShowDetail(BuildContext context, String id) {
    return FluroRouter.appRouter.navigateTo(
      context,
      '/tv/$id',
      transition: TransitionType.custom,
      transitionDuration: const Duration(milliseconds: 300),
      opaque: false,
      transitionBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static void defineRoutes() {
    if (_routesDefined) return;
    _routesDefined = true;

    FluroRouter.appRouter.define(
      '/',
      handler: Handler(handlerFunc: (_, _) => const AppShell()),
    );

    FluroRouter.appRouter.define(
      '/movie/:id',
      handler: Handler(
        handlerFunc: (_, parameters) {
          final id = parameters['id']?.first ?? '';
          return MovieDetailScreen(movieId: id);
        },
      ),
    );

    FluroRouter.appRouter.define(
      '/tv/:id',
      handler: Handler(
        handlerFunc: (_, parameters) {
          final id = parameters['id']?.first ?? '';
          return TvShowDetailScreen(tvShowId: id);
        },
      ),
    );

    FluroRouter.appRouter.define(
      '/search',
      handler: Handler(handlerFunc: (_, _) => const SearchScreen()),
    );
  }
}
