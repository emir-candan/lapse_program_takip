import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.moonColors?.goku,
      body: Center(
        child: Text(
          "Ana Sayfa",
          style: context.moonTypography?.heading.text24,
        ),
      ),
    );
  }
}