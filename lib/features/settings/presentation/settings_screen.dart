import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageLayout(
      title: "Ayarlar",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
           AppEmptyState(message: "Ayarlar sayfası hazırlanıyor..."),
        ],
      ),
    );
  }
}
