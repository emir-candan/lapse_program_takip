import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageLayout(
      title: "Programlar",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
           AppEmptyState(message: "Program listesi hazırlanıyor..."),
        ],
      ),
    );
  }
}
