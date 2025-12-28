import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../auth/presentation/providers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              "Hoşgeldiniz",
              style: context.moonTypography?.heading.text24,
            ),
            const SizedBox(height: 8),
            Text(
              "iddia",
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