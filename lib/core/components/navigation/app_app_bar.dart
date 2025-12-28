import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return MoonAppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Standard height
}
