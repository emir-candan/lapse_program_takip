import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppCarousel extends StatelessWidget {
  final List<Widget> items;
  final double? height;
  final double? itemExtent;

  const AppCarousel({
    super.key,
    required this.items,
    this.height, // If null, will fallback to token in initializer potentially, or use token as default param
    this.itemExtent,
  });
  
  // Default values need to be static const for params, but we can handle nulls in build
  // Let's make them nullable and use tokens in build to ensure strict theme adherence.

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppTheme.tokens.carouselHeight,
      child: MoonCarousel(
        itemCount: items.length,
        itemExtent: itemExtent ?? AppTheme.tokens.carouselItemExtent,
        itemBuilder: (context, index, realIndex) => items[index],
      ),
    );
  }
}
