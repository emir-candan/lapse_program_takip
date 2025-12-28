import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return MoonTooltip(
      show: false, // controlled by hover typically
      content: Text(message),
      child: child,
    );
  }
}
