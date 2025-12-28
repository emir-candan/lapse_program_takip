import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      MoonTheme(tokens: MoonTokens.light),
    ],
  );

  static final darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      MoonTheme(tokens: MoonTokens.dark),
    ],
  );
}