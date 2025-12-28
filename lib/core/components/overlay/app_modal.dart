import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

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
        // borderRadius: ... enforced by theme?
      ),
    );
  }

  static void showToast({
    required BuildContext context,
    required String message,
  }) {
    showMoonToast(
      context: context,
      label: Text(message),
    );
  }
}
