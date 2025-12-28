import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const AppEmptyState({
    super.key,
    this.message = "Veri bulunamadı.",
    this.icon = Icons.inbox_outlined, // MoonIcons usually preferred but IconData works
  });

  @override
  Widget build(BuildContext context) {
    return MoonEmptyState(
      label: Text(message),
      leading: Icon(icon, size: 48), // MoonEmptyState usually takes leading icon
    );
  }
}
