import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String? label;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final radio = MoonRadio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );

    if (label != null) {
      return GestureDetector(
        onTap: () => onChanged(value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radio,
            const SizedBox(width: 8),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }
    
    return radio;
  }
}
