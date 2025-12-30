import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageLayout(
      title: "Panel",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
           AppEmptyState(message: "Panel içeriği hazırlanıyor..."),
        ],
      ),
    );
  }
}