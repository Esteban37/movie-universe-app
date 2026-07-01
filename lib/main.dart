import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluro/fluro.dart';

import 'core/network/dio_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MovieUniverseApp()));
}

class MovieUniverseApp extends ConsumerWidget {
  const MovieUniverseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppRouter.defineRoutes();

    ref.read(dioProvider);

    return MaterialApp(
      title: 'Movie Universe',
      theme: AppTheme.lightTheme,
      onGenerateRoute: FluroRouter.appRouter.generator,
    );
  }
}
