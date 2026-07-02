import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('dark theme uses cinema noir palette without purple accent', () {
      final scheme = AppTheme.dark().colorScheme;

      expect(scheme.primary, const Color(0xFFE21A38));
      expect(scheme.tertiary, const Color(0xFFF5B731));
      expect(scheme.secondary, const Color(0xFF2A2A32));
      expect(scheme.surface, const Color(0xFF141418));
    });

    test('light theme mirrors accent colors', () {
      final scheme = AppTheme.light().colorScheme;

      expect(scheme.primary, const Color(0xFFC41E3A));
      expect(scheme.tertiary, const Color(0xFFD4A017));
    });

    test('text theme uses Source Sans 3 across roles', () {
      final textTheme = AppTheme.dark().textTheme;

      expect(textTheme.headlineMedium?.fontFamily, AppTheme.fontFamily);
      expect(textTheme.titleSmall?.fontFamily, AppTheme.fontFamily);
      expect(textTheme.bodyLarge?.fontFamily, AppTheme.fontFamily);
      expect(textTheme.labelMedium?.fontFamily, AppTheme.fontFamily);
    });

    test('headline and title tokens have distinct weights', () {
      final textTheme = AppTheme.dark().textTheme;

      expect(textTheme.headlineSmall?.fontWeight, FontWeight.w700);
      expect(textTheme.titleLarge?.fontWeight, FontWeight.w600);
      expect(textTheme.titleSmall?.fontWeight, FontWeight.w600);
      expect(textTheme.bodyLarge?.fontWeight, FontWeight.w400);
    });

    test('navigation bar uses primary indicator', () {
      final navTheme = AppTheme.dark().navigationBarTheme;

      expect(
        navTheme.indicatorColor,
        AppTheme.dark().colorScheme.primaryContainer,
      );
    });
  });
}
