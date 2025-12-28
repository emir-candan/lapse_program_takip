import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTag extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppTag({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return MoonTag(
      label: Text(label),
      onTap: onTap,
      backgroundColor: backgroundColor,
      // Radius will be handled strictly by AppTheme if MoonTag uses BorderRadius tokens.
      // If not, we can force it here: borderRadius: BorderRadius.circular(AppTheme.radius)
    );
  }
}
