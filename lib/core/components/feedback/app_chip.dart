import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.onRemove,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MoonChip(
      label: Text(label),
      leading: icon != null ? Icon(icon, size: AppTheme.tokens.chipIconSize) : null,
      onTap: onRemove,
      borderRadius: BorderRadius.circular(AppTheme.tokens.chipRadius), 
    );
  }
}
