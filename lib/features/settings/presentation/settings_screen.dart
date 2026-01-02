import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageLayout(
      title: "Ayarlar",
      child: Column(
        children: [
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
          AppCard(
            child: Row(
              children: [
                Icon(
                  MoonIcons.other_frame_24_regular,
                  color: AppTheme.colors(context).textSecondary,
                ),
                const SizedBox(width: 16),
                Text(
                  "Genel Ayarlar (Yakında)",
                  style: context.moonTypography?.body.text16.copyWith(
                    color: AppTheme.colors(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
