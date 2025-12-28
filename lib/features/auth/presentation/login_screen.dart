import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/theme/theme_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Moon Design tokenlarına erişim
    final moonColors = context.moonColors;
    final moonTypography = context.moonTypography;

    return Scaffold( // MoonScaffold yoksa standard Scaffold kullanabiliriz, ama arka plan rengini moonColors.goku yaparız
      backgroundColor: moonColors?.goku,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Logo veya Başlık
              Text(
                "LAPSE",
                style: moonTypography?.heading.text32.copyWith(
                  fontWeight: FontWeight.bold,
                  color: moonColors?.piccolo, // Ana marka rengi
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
                    MoonTextInput(
                      hintText: "E-posta",
                      onChanged: (value) {},
                      // leading: const Icon(MoonIcons.mail_24_regular), // Error
                      leading: const Icon(Icons.email),
                    ),
                    const SizedBox(height: 16),
                    MoonTextInput(
                      hintText: "Şifre",
                      obscureText: true,
                      onChanged: (value) {},
                      // leading: const Icon(MoonIcons.security_24_regular), // Error
                      leading: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: MoonFilledButton(
                        label: const Text("Giriş Yap"),
                        onTap: () {
                          // Giriş işlemleri
                        },
                      ),
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