import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final checkbox = MoonCheckbox(
      value: value,
      onChanged: onChanged,
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          const SizedBox(width: 8),
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }
    
    return checkbox;
  }
}
