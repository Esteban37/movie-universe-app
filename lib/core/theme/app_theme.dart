import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _nearBlack = Color(0xFF0D0D0D);
  static const _surfaceDark = Color(0xFF1A1A1A);
  static const _surfaceVariantDark = Color(0xFF2A2A2A);
  static const _rappiRed = Color(0xFFE50914);
  static const _cosmicPurple = Color(0xFF7367F0);
  static const _teal = Color(0xFF00BFA5);
  static const _warmWhite = Color(0xFFFAFAF8);
  static const _textPrimaryDark = Color(0xFFF0EFEC);
  static const _textSecondaryDark = Color(0xFF9E9E9E);

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _rappiRed,
    onPrimary: Colors.white,
    secondary: _cosmicPurple,
    onSecondary: Colors.white,
    tertiary: _teal,
    onTertiary: Colors.white,
    error: Color(0xFFFF5252),
    onError: Colors.white,
    surface: _surfaceDark,
    onSurface: _textPrimaryDark,
    onSurfaceVariant: _textSecondaryDark,
    surfaceContainerHighest: _surfaceVariantDark,
    outline: Color(0xFF49454F),
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFC62828),
    onPrimary: Colors.white,
    secondary: Color(0xFF5E35B1),
    onSecondary: Colors.white,
    tertiary: Color(0xFF00897B),
    onTertiary: Colors.white,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF1C1B1F),
    onSurfaceVariant: Color(0xFF6E6E6E),
    surfaceContainerHighest: Color(0xFFF0EFEC),
    outline: Color(0xFF79747E),
  );

  static const _appTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      height: 1.22,
      letterSpacing: -0.25,
    ),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.33,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 1.27,
      letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.5,
    ),
  );

  static ThemeData dark() => _baseTheme(Brightness.dark, _darkColorScheme);

  static ThemeData light() => _baseTheme(Brightness.light, _lightColorScheme);

  static ThemeData _baseTheme(Brightness brightness, ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: _appTextTheme,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? _nearBlack
          : _warmWhite,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: brightness == Brightness.dark
            ? _surfaceDark.withValues(alpha: 0.8)
            : colorScheme.surface.withValues(alpha: 0.8),
      ),
      cardTheme: CardThemeData(
        elevation: brightness == Brightness.dark ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        filled: true,
      ),
    );
  }
}
