import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppLoader extends StatelessWidget {
  final double size;
  
  const AppLoader({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: MoonCircularLoader(
        color: Theme.of(context).primaryColor,
        // Enforce circular shape logic if needed, but loader is standard.
      ),
    );
  }
}
