import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

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
      borderRadius: BorderRadius.circular(AppTheme.tokens.tagRadius),
    );
  }
}
