import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? iconSize;
  final double? padding;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // MoonIconButton might not exist in 1.1.0, fallback to MoonButton with no label or standard IconButton
    // Let's use standard Flutter IconButton to be safe but wrap in Theme

    // Check if MoonFilledIconButton exists? Maybe.
    // Safest bet for "Pure Control" is manually styled Container.

    return Tooltip(
      message: tooltip ?? "",
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.tokens.iconButtonRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(
              padding ?? AppTheme.tokens.iconButtonPadding,
            ),
            child: Icon(
              icon,
              color: color ?? AppTheme.colors(context).brand,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
