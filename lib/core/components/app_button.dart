import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

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
          ? const SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
          : Text(label),
      // MoonFilledButton uses context.moonTheme.tokens by default,
      // which we have overridden in AppDesignSystem.
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    
    return button;
  }
}
