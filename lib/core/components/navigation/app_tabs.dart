import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppTabs extends StatelessWidget {
  final List<Widget> tabs;
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
    return MoonTabBar(
      tabController: controller,
      onTabChanged: onChanged,
      tabs: tabs, // Expects lists of MoonTab usually
    );
  }
}
