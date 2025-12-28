import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_design_system.dart';

class AppTheme {
  AppTheme._();

  // ==============================================================================
  // 🎛️ CONTROL PANEL
  // Define *WHAT* the design should be here.
  // ==============================================================================

  // 1. BRAND COLORS
  static const Color _brandColor = Color(0xFF009944); 
  
  // 2. BACKGROUNDS
  static const Color _lightBg = Color(0xFFFFFFFF);
  static const Color _darkBg = Color(0xFF161618);
  static const Color _lightSurface = Color(0xFFF6F7F9);
  static const Color _darkSurface = Color(0xFF232325);

  // 3. TYPOGRAPHY
  static TextStyle get _mainFont => GoogleFonts.urbanist();

  // 4. SHAPES (Radius & Borders)
  // Change these to instantly reshape the entire app
  static const double _defaultRadius = 1.0; 
  static const double _borderWidth = 2.0; 

  // ==============================================================================
  // 🚀 LAUNCH THEME
  // Do not modify below. Logic is handled in AppDesignSystem.
  // ==============================================================================

  static final lightTheme = AppDesignSystem.getStrictTheme(
    isDarkMode: false,
    brandColor: _brandColor,
    backgroundColor: _lightBg,
    surfaceColor: _lightSurface,
    fontStyle: _mainFont,
    defaultRadius: _defaultRadius,
    borderWidth: _borderWidth,
  );

  static final darkTheme = AppDesignSystem.getStrictTheme(
    isDarkMode: true,
    brandColor: _brandColor,
    backgroundColor: _darkBg,
    surfaceColor: _darkSurface,
    fontStyle: _mainFont,
    defaultRadius: _defaultRadius,
    borderWidth: _borderWidth,
  );
}