import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Eklendi
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart'; // ✅ Eklendi
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Web/PWA için offline persistence'ı aktif et
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    // Web specific call if needed, but 'settings' covers most.
    // actually, enablePersistence is a method.
    // await FirebaseFirestore.instance.enablePersistence();
    // The new way is usually automatic or via settings?
    // Let's stick to valid API.
    // For web, enablePersistence() is the standard.
  } catch (e) {
    debugPrint("Persistence error: $e");
  }

  await Hive.initFlutter();
  await Hive.openBox('settings'); // Ayarlar kutusunu açtığımızdan emin oluyoruz

  runApp(const ProviderScope(child: LapseApp()));
}

class LapseApp extends ConsumerWidget {
  const LapseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // ✅ ARTIK DİNAMİK: Provider'ı dinliyoruz
    final currentThemeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Lapse',
      debugShowCheckedModeBanner: false,

      // KULLANICI SEÇİMİ BURAYA GELİYOR
      themeMode: currentThemeMode,

      // Temalar (Sabit)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      routerConfig: router,
    );
  }
}
