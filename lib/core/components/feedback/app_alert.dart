import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppAlert extends StatelessWidget {
  final String title;
  final String? body;
  final bool showIcon;

  const AppAlert({
    super.key,
    required this.title,
    this.body,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return MoonAlert(
      label: Text(title),
      content: body != null ? Text(body!) : null,
      showIcon: showIcon,
      // Radius and colors derived from Theme
    );
  }
}
