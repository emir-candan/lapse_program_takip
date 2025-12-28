import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppCarousel extends StatelessWidget {
  final List<Widget> items;
  final double height;

  const AppCarousel({
    super.key,
    required this.items,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: MoonCarousel(
        itemCount: items.length,
        itemBuilder: (context, index, realIndex) => items[index],
        // Additional MoonCarousel params...
      ),
    );
  }
}
