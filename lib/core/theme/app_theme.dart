import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_design_system.dart';

class AppTheme {
  AppTheme._();

  // 1. RENKLER (Light: Canlı, Dark: Tok)
  static const Color _brandColorLight = Color(0xFF079F00); 
  static const Color _brandColorDark = Color(0xFF057A00); 
  
  // 2. ARKA PLANLAR (Zinc - Nötr Griler)
  static const Color _lightBg = Color(0xFFF8FAFC); 
  static const Color _lightSurface = Color(0xFFFFFFFF); 
  static const Color _darkBg = Color(0xFF121212); // Daha yumuşak, standart dark mode siyahı
  static const Color _darkSurface = Color(0xFF1E1E1E); // Yüzeyler için biraz daha açık ton 

  // 3. TİPOGRAFİ
  static TextStyle get _mainFont => GoogleFonts.montserrat();

  // 4. ŞEKİLLER & GÖLGELER
  static const double _defaultRadius = 12.0;
  static const double _borderWidth = 1.0;

  static final List<BoxShadow> _cardShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.08), offset: const Offset(0, 4), blurRadius: 24, spreadRadius: -2),
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 2), blurRadius: 8, spreadRadius: 0),
  ];

  static final List<BoxShadow> _cardShadowDark = [
    BoxShadow(color: Colors.black.withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 24, spreadRadius: -2),
    BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8, spreadRadius: 0),
  ];

  static const _AppTokens tokens = _AppTokens();

  // ==============================================================================
  static AppColors colors(BuildContext context) => Theme.of(context).extension<AppColors>()!;

  // ==============================================================================
  // 🚀 TEMALARI BAŞLAT (STATİK)
  // ==============================================================================

  static final lightTheme = AppDesignSystem.getStrictTheme(
    isDarkMode: false,
    brandColor: _brandColorLight,
    backgroundColor: _lightBg,
    surfaceColor: _lightSurface,
    fontStyle: _mainFont,
    defaultRadius: _defaultRadius,
    borderWidth: _borderWidth,
    extensions: [_lightColors],
  );

  static final darkTheme = AppDesignSystem.getStrictTheme(
    isDarkMode: true,
    brandColor: _brandColorDark,
    backgroundColor: _darkBg,
    surfaceColor: _darkSurface,
    fontStyle: _mainFont,
    defaultRadius: _defaultRadius,
    borderWidth: _borderWidth,
    extensions: [_darkColors],
  );

  // --- Renk Tanımları ---
  static final _lightColors = AppColors(
    brand: _brandColorLight,
    onBrand: Colors.white,
    background: _lightBg,
    surface: _lightSurface,
    textPrimary: const Color(0xFF0F172A), // Slate 900
    textSecondary: const Color(0xFF64748B), // Slate 500
    border: const Color(0xFFE2E8F0), // Slate 200
    error: const Color(0xFFEF4444), // Red 500
    success: const Color(0xFF22C55E), // Green 500
    warning: const Color(0xFFF59E0B), // Amber 500
    sidebar: const Color(0xFFF1F5F9), // Slate 100
  );

  static final _darkColors = AppColors(
    brand: _brandColorDark,
    onBrand: Colors.white,
    background: _darkBg,
    surface: _darkSurface,
    textPrimary: const Color(0xFFF8FAFC), // Slate 50
    textSecondary: const Color(0xFF94A3B8), // Slate 400
    border: const Color(0xFF30363D), // Zinc derivative
    error: const Color(0xFFEF4444), // Red 500
    success: const Color(0xFF22C55E), // Green 500
    warning: const Color(0xFFF59E0B), // Amber 500
    sidebar: const Color(0xFF18181B), // Zinc 900 (Slightly lighter than bg #121212)
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color brand;
  final Color onBrand;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color error;
  final Color success;
  final Color warning;
  final Color sidebar;

  const AppColors({
    required this.brand,
    required this.onBrand,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.error,
    required this.success,
    required this.warning,
    required this.sidebar,
  });

  @override
  AppColors copyWith({
    Color? brand,
    Color? onBrand,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? error,
    Color? success,
    Color? warning,
    Color? sidebar,
  }) {
    return AppColors(
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      sidebar: sidebar ?? this.sidebar,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
    );
  }
}

// Token sınıfı değişmedi, aynen kalacak (silmeyin).
class _AppTokens {
  const _AppTokens();
  // ... (Eski kodlarınızdaki içerik aynen burada olmalı)
  static const double _baseSpacing = 8.0; 
  static const double _baseRadius = 12.0; 

  final double spacingXs = _baseSpacing / 2;
  final double spacingSm = _baseSpacing;
  final double spacingMd = _baseSpacing * 2;
  final double spacingLg = _baseSpacing * 3;
  final double spacingXl = _baseSpacing * 4;

  final double radiusSm = _baseRadius - 4.0;
  final double radiusMd = _baseRadius;
  final double radiusLg = _baseRadius + 4.0;

  List<BoxShadow> get cardShadowLight => AppTheme._cardShadow;
  List<BoxShadow> get cardShadowDark => AppTheme._cardShadowDark;

  // Shared shadow for Sidebar and AppBar
  List<BoxShadow> get layoutShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 0), // Center shadow for uniformity or adjust per usage? 
      // User said "same setting". Let's use a subtle directed shadow or ambient.
      // Ambient (0,0) is safest for "same setting" looking "compatible".
      // Or we can define it and overload it. 
      // Let's go with a standard light depth.
    )
  ];

  final FontWeight buttonTextWeight = FontWeight.w600;
  final EdgeInsets inputContentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  final bool inputIsDense = true;

  EdgeInsets get segmentedControlPadding => EdgeInsets.all(spacingXs);
  EdgeInsets get segmentedControlInnerPadding => EdgeInsets.symmetric(vertical: spacingSm);
  double get segmentedControlRadius => radiusSm;
  
  List<BoxShadow> get segmentedControlShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    )
  ];

  double get tagSpacing => spacingSm;
  final double tagIconSize = 14.0;
  double get tagRadius => radiusXs; 
  final double radiusXs = 4.0;

  EdgeInsets get cardPadding => EdgeInsets.all(spacingLg);
  double get formLabelSpacing => spacingSm;

  final double sliderTrackHeight = 6.0;
  final double sliderThumbRadius = 10.0;
  final double sliderOverlayRadius = 20.0;
  final double sliderInactiveTrackOpacity = 0.15;
  final double sliderOverlayOpacity = 0.1;

  final double ratingStarSize = 28.0;
  final double ratingItemPadding = 2.0;
  final Color ratingActiveColor = const Color(0xFFFFCA28);
  final Color ratingInactiveColor = const Color(0xFFE2E8F0);

  final double chipRadius = 100.0;
  final double chipIconSize = 16.0;

  final double appBarHeight = 56.0;
  final double appBarElevation = 0.0;

  final double codeInputWidth = 50.0;
  double get codeInputSpacing => spacingXs;

  final double fileUploaderHeight = 120.0;
  final double fileUploaderIconSize = 32.0;

  final double carouselHeight = 200.0;
  final double carouselItemExtent = 300.0;

  final double emptyStateIconSize = 64.0;
  double get emptyStateSpacing => spacingMd;

  double get iconButtonPadding => spacingSm;
  double get iconButtonRadius => radiusSm;
  
  double get imageDefaultRadius => radiusMd;

  final double loaderSize = 24.0;
  final double loaderStrokeWidth = 3.0;

  double get skeletonDefaultRadius => radiusMd;
}