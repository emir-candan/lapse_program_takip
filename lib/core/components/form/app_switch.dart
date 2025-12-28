import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MoonSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}
