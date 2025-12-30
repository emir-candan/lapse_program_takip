import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppSegmentedControl extends StatelessWidget {
  final Map<int, Widget> children;
  final int value;
  final ValueChanged<int?>? onValueChanged;

  const AppSegmentedControl({
    super.key,
    required this.children,
    required this.value,
    this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.tokens.segmentedControlPadding,
      decoration: BoxDecoration(
        color: AppTheme.colors(context).surface, 
        borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
        border: Border.all(color: AppTheme.colors(context).border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children.entries.map((entry) => _buildSegment(context, entry)).toList(),
      ),
    );
  }

  Widget _buildSegment(BuildContext context, MapEntry<int, Widget> entry) {
    final isSelected = entry.key == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onValueChanged?.call(entry.key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppTheme.tokens.segmentedControlInnerPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.colors(context).brand : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.tokens.segmentedControlRadius),
            boxShadow: isSelected ? AppTheme.tokens.segmentedControlShadow : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: isSelected ? AppTheme.colors(context).onBrand : AppTheme.colors(context).textSecondary,
              fontWeight: isSelected ? AppTheme.tokens.buttonTextWeight : FontWeight.normal,
            ),
            child: entry.value, // User provided widget (Text usually)
          ),
        ),
      ),
    );
  }
}
