import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch radius from strict theme system
    final borderRadius = context.moonTheme?.tokens.borders.interactiveMd ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: borderRadius,
      child: MoonImage(
        image: NetworkImage(url),
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
