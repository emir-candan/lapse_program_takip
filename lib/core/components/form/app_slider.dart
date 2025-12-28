import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: AppTheme.tokens.sliderTrackHeight,
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(AppTheme.tokens.sliderInactiveTrackOpacity),
        thumbColor: Theme.of(context).primaryColor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: AppTheme.tokens.sliderThumbRadius),
        overlayShape: RoundSliderOverlayShape(overlayRadius: AppTheme.tokens.sliderOverlayRadius),
        overlayColor: Theme.of(context).primaryColor.withOpacity(AppTheme.tokens.sliderOverlayOpacity),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
      ),
    );
  }
}
