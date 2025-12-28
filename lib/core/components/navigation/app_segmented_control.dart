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
        color: context.moonColors?.gohan, 
        borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
        border: Border.all(color: context.moonColors?.beerus ?? Colors.transparent),
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
            color: isSelected ? context.moonColors?.piccolo : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.tokens.segmentedControlRadius),
            boxShadow: isSelected ? AppTheme.tokens.segmentedControlShadow : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: isSelected ? (context.moonColors?.goten ?? Colors.white) : context.moonColors?.textSecondary,
              fontWeight: isSelected ? AppTheme.tokens.buttonTextWeight : FontWeight.normal,
              fontFamily: AppTheme.tokens.buttonTextWeight.toString().contains("600") ? "Inter" : null, // Font inheritance usually handled by Theme but explicit here
            ),
            child: entry.value, // User provided widget (Text usually)
          ),
        ),
      ),
    );
  }
}
