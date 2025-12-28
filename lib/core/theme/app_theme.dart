import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_design_system.dart';

class AppTheme {
  AppTheme._();

  // ==============================================================================
  // 🎛️ CONTROL PANEL
  // Define *WHAT* the design should be here.
  // ==============================================================================

  // 1. BRAND COLORS (Indigo / "Stripe-like" Purple-Blue for Trust)
  static const Color _brandColor = Color(0xFF4F46E5); // Indigo 600
  
  // 2. BACKGROUNDS (Slate / Cool Greys for Modern Feel)
  static const Color _lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color _darkBg = Color(0xFF020617); // Slate 950
  static const Color _lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color _darkSurface = Color(0xFF0F172A); // Slate 900

  // 3. TYPOGRAPHY
  static TextStyle get _mainFont => GoogleFonts.inter(); // Inter is the standard for SaaS

  // 4. SHAPES (Radius & Borders)
  // Change these to instantly reshape the entire app
  static const double _defaultRadius = 12.0; // Slightly tighter for "Pro" feel
  static const double _borderWidth = 1.0; // Thinner borders are more elegant 

  // 5. SHADOWS & ELEVATION
  static final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 4),
      blurRadius: 24,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> _cardShadowDark = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      offset: const Offset(0, 4),
      blurRadius: 24,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // ==============================================================================
  // 6. EXPOSED TOKENS (For Components)
  // Components should access these via AppTheme.tokens...
  // ==============================================================================
  
  static const _AppTokens tokens = _AppTokens();

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
  ).copyWith(
    // We can inject custom shadows into the theme extension if needed, 
    // or just use static access for specific custom components.
    // For now, let's keep it simple.
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

// Immutable Tokens Class
class _AppTokens {
  const _AppTokens();

  final double spacingXs = 4.0;
  final double spacingSm = 8.0;
  final double spacingMd = 16.0;
  final double spacingLg = 24.0;
  final double spacingXl = 32.0;

  final double radiusSm = 8.0;
  final double radiusMd = 12.0; // Matches _defaultRadius
  final double radiusLg = 16.0;
  
  // Shadows (Getter to handle potential logic or just raw exposure)
  List<BoxShadow> get cardShadowLight => AppTheme._cardShadow;
  List<BoxShadow> get cardShadowDark => AppTheme._cardShadowDark;

  // Component Specifics (Strictly centralized)
  final FontWeight buttonTextWeight = FontWeight.w600;
  final EdgeInsets inputContentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  final bool inputIsDense = true;

  // Segmented Control
  final EdgeInsets segmentedControlPadding = const EdgeInsets.all(4);
  final EdgeInsets segmentedControlInnerPadding = const EdgeInsets.symmetric(vertical: 8);
  final double segmentedControlRadius = 8.0;
  List<BoxShadow> get segmentedControlShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    )
  ];

  // Tag Input & Display
  final double tagSpacing = 8.0;
  final double tagIconSize = 14.0;
  final double tagRadius = 4.0; // Standard small tag radius

  // Layout - Card
  final EdgeInsets cardPadding = const EdgeInsets.all(24.0);

  // Forms - Checkbox & Radio
  final double formLabelSpacing = 8.0;
  
  // Forms - Slider
  final double sliderTrackHeight = 6.0;
  final double sliderThumbRadius = 10.0;
  final double sliderOverlayRadius = 20.0;
  final double sliderInactiveTrackOpacity = 0.15;
  final double sliderOverlayOpacity = 0.1;

  // Forms - Rating
  final double ratingStarSize = 28.0;
  final double ratingItemPadding = 2.0;
  final Color ratingActiveColor = const Color(0xFFFFCA28); // Amber 400 manually defined for control
  final Color ratingInactiveColor = const Color(0xFFE2E8F0); // Slate 200

  // Display - Chip
  final double chipRadius = 100.0;
  final double chipIconSize = 16.0;

  // Navigation - AppBar
  final double appBarHeight = 56.0;
  final double appBarElevation = 0.0; // Flat style by default
  // Forms - Code Input
  final double codeInputWidth = 50.0;
  final double codeInputSpacing = 4.0;
  
  // Forms - File Uploader
  final double fileUploaderHeight = 120.0;
  final double fileUploaderIconSize = 32.0;
  
  // Display - Carousel
  final double carouselHeight = 200.0;
  final double carouselItemExtent = 300.0;
  
  // Display - Empty State
  final double emptyStateIconSize = 64.0;
  final double emptyStateSpacing = 16.0;

  // Display - Icon Button
  final double iconButtonPadding = 8.0;
  final double iconButtonRadius = 8.0; // Fallback if theme borders missing
  
  // Display - Image
  final double imageDefaultRadius = 12.0;

  // Feedback - Loader
  final double loaderSize = 24.0;
  final double loaderStrokeWidth = 3.0;

  // Feedback - Skeleton
  final double skeletonDefaultRadius = 12.0;
}