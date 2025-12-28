import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/components/components.dart';
import '../../../core/theme/theme_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moonColors = context.moonColors;
    final moonTypography = context.moonTypography;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Logo ve Başlık
              Text(
                "LAPSE",
                style: moonTypography?.heading.text32.copyWith(
                  fontWeight: FontWeight.bold,
                  color: moonColors?.piccolo,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Program Takip Sistemi",
                style: moonTypography?.body.text16.copyWith(
                  color: moonColors?.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // Form Alanı
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    AppTextInput(
                      hintText: "E-posta",
                      prefixIcon: Icons.email,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    AppTextInput(
                      hintText: "Şifre",
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 32),
                    
                    AppButton(
                      label: "Giriş Yap",
                      onTap: () {
                        // Giriş işlemi
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              // Tema Değiştirme Butonu (Demo amaçlı)
              MoonOutlinedButton(
                label: const Text("Tema Değiştir"),
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}