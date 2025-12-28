import 'package:flutter/material.dart';
import '../../../core/components/components.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchTap;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hintText = "Ara...",
    this.onChanged,
    this.onSearchTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Reusing AppTextInput ensures consistency with other inputs!
    return AppTextInput(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      // We could add a suffix icon for 'Clear' or 'Filter' later
    );
  }
}
