import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

/// Standard Primary Button for Lapse.
///
/// Wraps [MoonFilledButton] to ensure design system consistency.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = MoonFilledButton(
      onTap: isLoading ? null : onTap,
      label: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.colors(context).onBrand,
                ),
                strokeWidth: AppTheme.tokens.loaderStrokeWidth,
              ),
            )
          : Text(
              label,
              style: TextStyle(fontWeight: AppTheme.tokens.buttonTextWeight),
            ),
      // MoonFilledButton uses context.moonTheme.tokens by default,
      // which we have overridden in AppDesignSystem.
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
