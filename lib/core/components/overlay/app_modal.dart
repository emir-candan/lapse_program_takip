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
    // Switching to standard showDialog for "Popup" feel as requested.
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor:
            Colors.transparent, // We handle styling in the child container
        insetPadding: EdgeInsets.all(
          AppTheme.tokens.spacingMd,
        ), // Margin from screen edges
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 500,
            ), // Max width for tablet/desktop
            decoration: BoxDecoration(
              color: AppTheme.colors(context).surface,
              borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
              boxShadow: AppTheme.tokens.cardShadowLight,
            ),
            padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
            child: child,
          ),
        ),
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
