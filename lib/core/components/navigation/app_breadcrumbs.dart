import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppBreadcrumbs extends StatelessWidget {
  final List<Widget> items;

  const AppBreadcrumbs({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Map generic widgets to MoonBreadcrumbItem
    // Assuming generic widgets are Texts
    final moonItems = items.map((w) => MoonBreadcrumbItem(label: w)).toList();
    
    return MoonBreadcrumb(
      items: moonItems,
    );
  }
}
