import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/theme/theme_provider.dart';

import '../../helpers/provider_container.dart';

void main() {
  test('themeModeProvider defaults to dark', () {
    final container = createTestContainer();

    final themeMode = container.read(themeModeProvider);
    expect(themeMode, ThemeMode.dark);
  });

  test('themeModeProvider can be set to light', () {
    final container = createTestContainer();

    container.read(themeModeProvider.notifier).state = ThemeMode.light;
    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('themeModeProvider can be set to system', () {
    final container = createTestContainer();

    container.read(themeModeProvider.notifier).state = ThemeMode.system;
    expect(container.read(themeModeProvider), ThemeMode.system);
  });
}
