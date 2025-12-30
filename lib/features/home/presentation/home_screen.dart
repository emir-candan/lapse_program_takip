import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../auth/presentation/providers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;

    return Scaffold(
      backgroundColor: context.moonColors?.goku,
      appBar: AppBar(
        title: Text(
          "Ana Sayfa",
          style: context.moonTypography?.heading.text20,
        ),
        backgroundColor: context.moonColors?.goku,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.square_arrow_right),
              tooltip: "Çıkış Yap",
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hoşgeldiniz, ${user?.name ?? ''}",
              style: context.moonTypography?.heading.text24,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: user?.isAdmin == true ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: user?.isAdmin == true ? Colors.red : Colors.blue,
                ),
              ),
              child: Text(
                "Role: ${user?.role ?? 'Bilinmiyor'}",
                style: context.moonTypography?.body.text14.copyWith(
                  color: user?.isAdmin == true ? Colors.red : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Program Takip Sistemi",
              style: context.moonTypography?.body.text16.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}