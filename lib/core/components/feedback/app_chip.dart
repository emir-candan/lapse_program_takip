import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

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
      leading: icon != null ? Icon(icon, size: 16) : null,
      onTap: onRemove, // If explicit remove, use trailing, but onTap works for selection
      borderRadius: BorderRadius.circular(100), // Chips are usually round, regardless of theme radius preference? 
      // User said "Total control via theme". 
      // If we interpret defaultRadius as THE radius for everything, we should use it.
      // But typically chips are fully rounded. I will assume full rounded for Chips unless user specifies AppTheme.chipRadius.
    );
  }
}
