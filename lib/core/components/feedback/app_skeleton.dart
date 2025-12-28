import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
         width: width,
         height: height,
         decoration: BoxDecoration(
           borderRadius: borderRadius != null 
               ? BorderRadius.circular(borderRadius!) 
               : (context.moonTheme?.tokens.borders.interactiveMd ?? BorderRadius.circular(12)),
           // MoonSkeleton usually involves an animation, if not available in this version:
           color: context.moonColors?.beerus,
         ),
    );
     // MoonSkeleton class usage if available:
     // return MoonSkeleton(...)
  }
}
