import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  
  @override
  ThemeMode build() {
    return _loadThemeFromHive();
  }

  // 1. Belirli bir temayı ayarla (Açık/Koyu/Sistem)
  void setTheme(ThemeMode mode) {
    state = mode;
    _saveThemeToHive(mode);
  }

  // ✅ EKLENEN KISIM: Tek tuşla geçiş (Toggle)
  // Eğer Koyu ise Açık yapar, diğer durumlarda (Açık veya Sistem) Koyu yapar.
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  void _saveThemeToHive(ThemeMode mode) {
    final box = Hive.box('settings');
    box.put('theme_mode', mode.toString());
  }

  ThemeMode _loadThemeFromHive() {
    final box = Hive.box('settings');
    final String? savedTheme = box.get('theme_mode');

    if (savedTheme == ThemeMode.light.toString()) {
      return ThemeMode.light;
    } else if (savedTheme == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}