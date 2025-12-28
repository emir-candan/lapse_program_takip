import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final Widget? content;
  final double size;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.content,
    this.size = 32.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return MoonAvatar(
      content: content,
      backgroundColor: backgroundColor,
      avatarSize: MoonAvatarSize.md, // Map double size to MoonSize if possible, or force size
      // MoonAvatar uses enum sizes usually. 
      // If we want exact double size control, we might need a Container wrapper.
      // For now, let's map loosely.
    );
  }
}
