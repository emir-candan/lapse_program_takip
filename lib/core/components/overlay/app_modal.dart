import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

/// Helper class to show standardized modals/bottom sheets.
class AppModal {
  AppModal._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showMoonModal<T>(
      context: context,
      builder: (context) => MoonModal(
        child: child,
      ),
    );
  }

  static void showToast({
    required BuildContext context,
    required String message,
  }) {
    // Correct usage based on Moon Design 1.0 conventions:
    // Safe usage for Moon Design:
    MoonToast.show(
      context,
      label: Text(message),
      variant: MoonToastVariant.original,
      backgroundColor: AppTheme.colors(context).surface,
      borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
      leading: const Icon(Icons.info_outline),
    );
  }
}
