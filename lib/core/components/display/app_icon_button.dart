import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // MoonIconButton automatically uses MoonTheme.tokens.borders.interactiveSm/Md
    return MoonIconButton(
      onTap: onTap,
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      backgroundColor: backgroundColor,
    );
  }
}
