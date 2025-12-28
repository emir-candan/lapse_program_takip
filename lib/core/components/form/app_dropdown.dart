import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

// Dropdowns are complex. MoonDropdown behaves like a popover.
// For simplicity in this architectural phase, we will wrap MoonDropdown
// but we might need to expose more params later.
class AppDropdown<T> extends StatelessWidget {
  final Widget content;
  final Widget child;
  final bool show;
  final ValueChanged<bool>? onShowChange;

  const AppDropdown({
    super.key,
    required this.show,
    required this.child,
    required this.content,
    this.onShowChange,
  });

  @override
  Widget build(BuildContext context) {
    return MoonDropdown(
      show: show,
      onTapOutside: () => onShowChange?.call(false),
      content: content,
      child: GestureDetector(
        onTap: () => onShowChange?.call(!show),
        child: child,
      ),
      // Theme enforced by AppDesignSystem (Radius, Shadows)
    );
  }
}
