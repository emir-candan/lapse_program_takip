import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

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
    // moon_ui_card.dart
    // MoonCard often doesn't take padding as param, acts as container.
    return MoonCard(
       backgroundColor: backgroundColor,
       child: Padding(
         padding: padding ?? const EdgeInsets.all(16.0),
         child: child,
       ),
    );
  }
}
