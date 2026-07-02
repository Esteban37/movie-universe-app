import 'package:flutter/material.dart';

/// Cinema Noir — warm dark surfaces, crimson accent, gold ratings.
class AppTheme {
  AppTheme._();

  static const fontFamily = 'Source Sans 3';

  // ── Surfaces ──────────────────────────────────────────────────────────────
  static const _scaffoldDark = Color(0xFF0A0A0C);
  static const _surfaceDark = Color(0xFF141418);
  static const _surfaceElevatedDark = Color(0xFF1E1E24);
  static const _scaffoldLight = Color(0xFFF7F6F2);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _surfaceElevatedLight = Color(0xFFF0EFE9);

  // ── Text ────────────────────────────────────────────────────────────────────
  static const _textPrimaryDark = Color(0xFFECEAE4);
  static const _textSecondaryDark = Color(0xFF94949E);
  static const _textPrimaryLight = Color(0xFF1A1A1F);
  static const _textSecondaryLight = Color(0xFF6E6E78);

  // ── Accents ─────────────────────────────────────────────────────────────────
  static const _crimson = Color(0xFFE21A38);
  static const _crimsonDark = Color(0xFF5C1224);
  static const _crimsonLight = Color(0xFFC41E3A);
  static const _crimsonContainerLight = Color(0xFFFFD9DE);
  static const _gold = Color(0xFFF5B731);
  static const _goldDark = Color(0xFF3D3018);
  static const _goldLight = Color(0xFFD4A017);
  static const _goldContainerLight = Color(0xFFFFF0C2);

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _crimson,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: _crimsonDark,
    onPrimaryContainer: Color(0xFFFFD9DE),
    secondary: Color(0xFF2A2A32),
    onSecondary: Color(0xFFE8E8EC),
    secondaryContainer: Color(0xFF23232A),
    onSecondaryContainer: Color(0xFFC4C4CC),
    tertiary: _gold,
    onTertiary: Color(0xFF1A1408),
    tertiaryContainer: _goldDark,
    onTertiaryContainer: Color(0xFFFFE089),
    error: Color(0xFFEF5350),
    onError: Color(0xFFFFFFFF),
    surface: _surfaceDark,
    onSurface: _textPrimaryDark,
    onSurfaceVariant: _textSecondaryDark,
    surfaceContainerHighest: _surfaceElevatedDark,
    outline: Color(0xFF42424D),
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _crimsonLight,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: _crimsonContainerLight,
    onPrimaryContainer: _crimsonDark,
    secondary: Color(0xFFE8E8EC),
    onSecondary: Color(0xFF2A2A32),
    secondaryContainer: Color(0xFFF0F0F4),
    onSecondaryContainer: Color(0xFF42424D),
    tertiary: _goldLight,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: _goldContainerLight,
    onTertiaryContainer: _goldDark,
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    surface: _surfaceLight,
    onSurface: _textPrimaryLight,
    onSurfaceVariant: _textSecondaryLight,
    surfaceContainerHighest: _surfaceElevatedLight,
    outline: Color(0xFF79747E),
  );

  /// Semantic type scale — single family, weight/size define hierarchy.
  ///
  /// | Role              | Token           | Size | Weight |
  /// |-------------------|-----------------|------|--------|
  /// | Hero (tablet)     | headlineMedium  | 22   | w700   |
  /// | Hero (phone)      | headlineSmall   | 18   | w700   |
  /// | Screen / bar title| titleLarge      | 18   | w600   |
  /// | Card title        | titleSmall      | 14   | w600   |
  /// | Tagline           | titleMedium     | 16   | w600   |
  /// | Body / overview   | bodyLarge       | 16   | w400   |
  /// | Metadata          | bodyMedium      | 14   | w400   |
  /// | Detail rating     | labelLarge      | 14   | w600   |
  /// | Card rating       | labelMedium     | 12   | w600   |
  /// | Chips             | labelSmall      | 11   | w600   |
  static const _appTextTheme = TextTheme(
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.55,
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
      letterSpacing: 0.1,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.35,
      letterSpacing: 0.2,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.25,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.3,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.4,
    ),
  );

  static ThemeData dark() => _baseTheme(Brightness.dark, _darkColorScheme);

  static ThemeData light() => _baseTheme(Brightness.light, _lightColorScheme);

  static ThemeData _baseTheme(Brightness brightness, ColorScheme colorScheme) {
    final textTheme = _appTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      fontFamily: fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? _scaffoldDark
          : _scaffoldLight,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        backgroundColor: brightness == Brightness.dark
            ? _surfaceDark.withValues(alpha: 0.92)
            : colorScheme.surface.withValues(alpha: 0.92),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: brightness == Brightness.dark
            ? _surfaceDark
            : colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelLarge?.copyWith(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: brightness == Brightness.dark ? 2 : 1,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.35)),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        deleteIconColor: colorScheme.onSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.35),
        thickness: 1,
      ),
    );
  }
}
