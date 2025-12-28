import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: AppTheme.tokens.appBarElevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.tokens.appBarHeight);
}
