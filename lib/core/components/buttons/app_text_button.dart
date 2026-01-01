import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

/// Standard Text/Ghost Button for Lapse.
///
/// Wraps [MoonTextButton] to ensure design system consistency.
/// Use this for secondary actions like "Forgot Password" or "Cancel".
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final Color? textColor;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isFullWidth = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = MoonTextButton(
      onTap: isLoading ? null : onTap,
      label: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? AppTheme.colors(context).textPrimary,
                ),
                strokeWidth: 2,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontWeight: AppTheme.tokens.buttonTextWeight,
                color: textColor,
              ),
            ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
