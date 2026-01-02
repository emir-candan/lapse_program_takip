import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'features/calendar/data/adapters/lesson_adapter.dart';
import 'features/calendar/data/adapters/exam_adapter.dart';
import 'features/calendar/data/adapters/subject_adapter.dart';
import 'features/calendar/data/adapters/schedule_settings_adapter.dart';
import 'features/calendar/data/datasources/calendar_local_datasource.dart';

// Global instance for provider access
final calendarLocalDatasource = CalendarLocalDatasource();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Web/PWA için offline persistence'ı aktif et
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint("Persistence error: $e");
  }

  // Hive initialization
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(ExamAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(ScheduleSettingsAdapter());

  // Open boxes
  await Hive.openBox('settings');
  await calendarLocalDatasource.init();

  runApp(const ProviderScope(child: LapseApp()));
}

class LapseApp extends ConsumerWidget {
  const LapseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final currentThemeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Lapse',
      debugShowCheckedModeBanner: false,
      themeMode: currentThemeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
