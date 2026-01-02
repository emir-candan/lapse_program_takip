import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';
import '../../../../core/components/buttons/theme_toggle.dart';
import '../../auth/presentation/providers/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;

    return AppPageLayout(
      title: "Ayarlar",
      child: Column(
        children: [
          // Schedule Settings
          AppCard(
            onTap: () => context.push('/schedule-settings'),
            child: Row(
              children: [
                Icon(
                  MoonIcons.time_time_24_regular,
                  color: AppTheme.colors(context).brand,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ders Programı Ayarları",
                        style: context.moonTypography?.heading.text16,
                      ),
                      Text(
                        "Okul saatleri, teneffüsler ve ders sürelerini düzenle",
                        style: context.moonTypography?.body.text12.copyWith(
                          color: AppTheme.colors(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  MoonIcons.controls_chevron_right_24_regular,
                  color: AppTheme.colors(context).textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Appearance Settings
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      MoonIcons.other_moon_24_regular,
                      color: AppTheme.colors(context).brand,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Görünüm",
                          style: context.moonTypography?.heading.text16,
                        ),
                        Text(
                          "Karanlık/Aydınlık mod seçimi",
                          style: context.moonTypography?.body.text12.copyWith(
                            color: AppTheme.colors(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const ThemeToggle(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account Settings
          if (user != null)
            AppCard(
              onTap: () =>
                  _showResetPasswordConfirmation(context, ref, user.email),
              child: Row(
                children: [
                  Icon(
                    MoonIcons.security_lock_24_regular,
                    color: AppTheme.colors(context).brand,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Şifre Değiştir",
                          style: context.moonTypography?.heading.text16,
                        ),
                        Text(
                          "E-posta adresine sıfırlama bağlantısı gönder",
                          style: context.moonTypography?.body.text12.copyWith(
                            color: AppTheme.colors(context).textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    MoonIcons.controls_chevron_right_24_regular,
                    color: AppTheme.colors(context).textSecondary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showResetPasswordConfirmation(
    BuildContext context,
    WidgetRef ref,
    String email,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.colors(context).surface,
        title: Text(
          "Şifre Değiştir",
          style: context.moonTypography?.heading.text20,
        ),
        content: Text(
          "$email adresine şifre sıfırlama bağlantısı gönderilsin mi?",
          style: context.moonTypography?.body.text14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "İptal",
              style: TextStyle(color: AppTheme.colors(context).textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .resetPassword(email);
                if (context.mounted) {
                  AppModal.showToast(
                    context: context,
                    message: "Sıfırlama bağlantısı gönderildi.",
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  AppModal.showToast(
                    context: context,
                    message: "Hata oluştu: $e",
                  );
                }
              }
            },
            child: Text(
              "Gönder",
              style: TextStyle(color: AppTheme.colors(context).brand),
            ),
          ),
        ],
      ),
    );
  }
}
