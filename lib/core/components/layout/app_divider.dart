import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;

  const AppDivider({super.key, this.indent, this.endIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppTheme.colors(context).border,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
