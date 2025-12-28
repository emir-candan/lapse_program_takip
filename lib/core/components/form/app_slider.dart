import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return MoonSlider(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      // theme: if needed
    );
  }
}
