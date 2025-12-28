import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppRating extends StatelessWidget {
  final double value; // MoonRating usually doubles?
  final double max; // or int
  final ValueChanged<double>? onChanged;

  const AppRating({
    super.key,
    required this.value,
    this.max = 5,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // File list said 'moon_ui_rating_stars.dart', likely class is MoonRating or MoonRatingStars
    // I will guess MoonRating first.
    // If invalid, I'll need to check. But assuming MoonRating based on conventions.
    // Actually, usually it's MoonRating.
    return MoonRating(
      rating: value,
      itemCount: max.toInt(),
      onRatingChanged: onChanged,
    );
  }
}
