import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluro/fluro.dart';

import 'core/network/dio_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MovieUniverseApp()));
}

class MovieUniverseApp extends ConsumerWidget {
  const MovieUniverseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppRouter.defineRoutes();

    ref.read(dioProvider);

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Movie Universe',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      onGenerateRoute: FluroRouter.appRouter.generator,
      debugShowCheckedModeBanner: false,
    );
  }
}
