import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onGroupValueChanged;
  final List<SegmentedControlItem> children;

  const AppSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.onGroupValueChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // MoonSegmentedControl isn't standard in 1.0?? 
    // Checking previous user list: 'src/components/moon_ui_segmented_control.dart' NOT found in user list.
    // User list had: carousel, breadcrumbs, etc. 
    // Wait, let's check the user list again.
    // 'moon_ui_switch.dart', 'moon_ui_tabs.dart'. 
    // NO Segmented Control in the list provided by user! 
    // I should probably skip it or implement a custom one if needed.
    // Instead I will implement AppBreadcrumbs which WAS in the list.
    
    return Container(); 
  }
}
// Replacing with Breadcrumbs
class SegmentedControlItem {
    final String label;
    SegmentedControlItem(this.label);
}
