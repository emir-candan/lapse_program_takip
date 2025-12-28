import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppListItem extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // MoonMenuItem or standard ListTile?
    // Moon has MoonMenuItem.
    return MoonMenuItem(
      label: title,
      content: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
