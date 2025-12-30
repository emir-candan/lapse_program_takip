import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
       padding: padding ?? AppTheme.tokens.cardPadding,
       decoration: BoxDecoration(
         color: backgroundColor ?? AppTheme.colors(context).surface,
         borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
         boxShadow: isDark ? AppTheme.tokens.cardShadowDark : AppTheme.tokens.cardShadowLight,
         border: Border.all(
           color: AppTheme.colors(context).border,
           width: 1,
         ),
       ),
       child: child,
    );
  }
}
