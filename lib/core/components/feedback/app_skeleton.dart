import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

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
               : BorderRadius.circular(AppTheme.tokens.skeletonDefaultRadius), // Enforced static token pattern
           // MoonSkeleton usually involves an animation, if not available in this version:
           color: AppTheme.colors(context).border,
         ),
    );
     // MoonSkeleton class usage if available:
     // return MoonSkeleton(...)
  }
}
