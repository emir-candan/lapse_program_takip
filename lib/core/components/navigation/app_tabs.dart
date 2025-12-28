import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTabs extends StatelessWidget {
  final List<Widget> tabs; // Assuming these are labels or widgets for tabs
  final TabController? controller;
  final ValueChanged<int>? onChanged;

  const AppTabs({
    super.key,
    required this.tabs,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Map generic widgets to MoonTab
    final moonTabs = tabs.map((t) => MoonTab(label: t)).toList();

    return MoonTabBar(
      tabController: controller,
      onTabChanged: onChanged,
      tabs: moonTabs,
    );
  }
}
