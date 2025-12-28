import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:google_fonts/google_fonts.dart';

/// The "Engine Room" that strictly enforces design rules.
class AppDesignSystem {
  AppDesignSystem._();

  /// Generates a complete Flutter ThemeData that forces our rules upon everything everywhere.
  static ThemeData getStrictTheme({
    required bool isDarkMode,
    required Color brandColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required TextStyle fontStyle,
    required double defaultRadius,
    required double borderWidth,
  }) {
    // 1. Determine Base
    final baseTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    
    // 2. Generate Flutter-side overrides (Hybrid support)
    // This ensures even standard widgets (and Moon widgets falling back to standard) obey rules.
    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(width: borderWidth, color: brandColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(width: borderWidth, color: isDarkMode ? Colors.white24 : Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(width: borderWidth, color: brandColor),
      ),
    );

    // 3. Generate Moon-side overrides
    final moonTheme = _getMoonTheme(
      isDarkMode: isDarkMode,
      brandColor: brandColor,
      backgroundColor: backgroundColor,
      surfaceColor: surfaceColor,
      fontStyle: fontStyle,
      defaultRadius: defaultRadius,
      borderWidth: borderWidth,
    );

    // 4. Return the Final Enforced Theme
    return baseTheme.copyWith(
      primaryColor: brandColor,
      scaffoldBackgroundColor: backgroundColor,
      brightness: brightness,
      // Force Typography
      textTheme: TextTheme(
        displayLarge: fontStyle, displayMedium: fontStyle, displaySmall: fontStyle,
        headlineLarge: fontStyle, headlineMedium: fontStyle, headlineSmall: fontStyle,
        titleLarge: fontStyle, titleMedium: fontStyle, titleSmall: fontStyle,
        bodyLarge: fontStyle, bodyMedium: fontStyle, bodySmall: fontStyle,
        labelLarge: fontStyle, labelMedium: fontStyle, labelSmall: fontStyle,
      ).apply(
        bodyColor: isDarkMode ? Colors.white : Colors.black,
        displayColor: isDarkMode ? Colors.white : Colors.black, 
        fontFamily: fontStyle.fontFamily,
      ),
      // Force Inputs
      inputDecorationTheme: inputDecorationTheme,
      // Force Data Tables
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(backgroundColor),
        dataRowColor: WidgetStateProperty.all(surfaceColor),
        headingTextStyle: fontStyle.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        dataTextStyle: fontStyle.copyWith(color: isDarkMode ? Colors.white70 : Colors.black87),
        dividerThickness: borderWidth,
      ),
      // Extensions (Moon Design)
      extensions: [moonTheme],
    );
  }

  // --- Internal Moon Helpers ---

  static MoonTheme _getMoonTheme({
    required bool isDarkMode,
    required Color brandColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required TextStyle fontStyle,
    required double defaultRadius,
    required double borderWidth,
  }) {
    final baseTokens = isDarkMode ? MoonTokens.dark : MoonTokens.light;
    final baseColors = isDarkMode ? MoonColors.dark : MoonColors.light;

    return MoonTheme(
      tokens: baseTokens.copyWith(
        colors: baseColors.copyWith(
          piccolo: brandColor,
          goku: backgroundColor,
          gohan: surfaceColor,
        ),
        typography: _mapTypography(baseTokens.typography, fontStyle),
        borders: _mapBorders(baseTokens.borders, defaultRadius, borderWidth),
      ),
    );
  }

  static MoonTypography _mapTypography(MoonTypography base, TextStyle font) {
    return base.copyWith(
      heading: base.heading.apply(fontFamily: font.fontFamily),
      body: base.body.apply(fontFamily: font.fontFamily),
    );
  }

  static MoonBorders _mapBorders(MoonBorders base, double radius, double width) {
    return base.copyWith(
      defaultBorderWidth: width,
      interactiveXs: BorderRadius.circular(radius),
      interactiveSm: BorderRadius.circular(radius),
      interactiveMd: BorderRadius.circular(radius),
      surfaceXs: BorderRadius.circular(radius),
      surfaceSm: BorderRadius.circular(radius),
      surfaceMd: BorderRadius.circular(radius),
      surfaceLg: BorderRadius.circular(radius),
    );
  }
}
