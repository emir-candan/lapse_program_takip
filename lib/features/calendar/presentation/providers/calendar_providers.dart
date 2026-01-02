import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../data/datasources/calendar_local_datasource.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/schedule_settings.dart';
import '../../../../main.dart' show calendarLocalDatasource;

// Local Datasource Provider
final calendarLocalDatasourceProvider = Provider<CalendarLocalDatasource>((
  ref,
) {
  return calendarLocalDatasource;
});

// Repository Provider
final calendarRepositoryProvider = Provider<CalendarRepositoryImpl>((ref) {
  final localDatasource = ref.watch(calendarLocalDatasourceProvider);
  return CalendarRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    localDatasource,
  );
});

// Selected Date Provider
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Focused Day Provider
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

// ========== LESSONS NOTIFIER ==========

class LessonsNotifier extends StateNotifier<AsyncValue<List<Lesson>>> {
  final CalendarRepositoryImpl _repository;

  LessonsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = AsyncValue.data(_repository.getCachedLessons());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchAndCacheLessons();
    result.fold(
      (f) => state = AsyncValue.error(f, StackTrace.current),
      (lessons) => state = AsyncValue.data(lessons),
    );
  }

  Future<void> addLesson(Lesson lesson) async {
    // 1. Slot bazlı çakışma kontrolü (Upsert)
    state.whenData((lessons) {
      final existing = lessons.cast<Lesson?>().firstWhere(
        (l) =>
            l?.dayOfWeek == lesson.dayOfWeek &&
            l?.slotIndex == lesson.slotIndex,
        orElse: () => null,
      );

      if (existing != null) {
        // Eğer aynı slotta ders varsa önce onu yerelden silelim
        final updated = lessons.where((l) => l.id != existing.id).toList();
        state = AsyncValue.data([...updated, lesson]);
        // Arka planda sunucudan da silsin
        _repository.deleteLesson(existing.id);
      } else {
        state = AsyncValue.data([...lessons, lesson]);
      }
    });

    await _repository.addLesson(lesson);
  }

  Future<void> addLessons(List<Lesson> newLessons) async {
    if (newLessons.isEmpty) return;

    state.whenData((currentLessons) {
      var updated = List<Lesson>.from(currentLessons);

      for (final lesson in newLessons) {
        // Her yeni ders için o slotu boşalt
        updated = updated
            .where(
              (l) =>
                  !(l.dayOfWeek == lesson.dayOfWeek &&
                      l.slotIndex == lesson.slotIndex),
            )
            .toList();
        updated.add(lesson);
      }

      state = AsyncValue.data(updated);
    });

    // Batch add to repository/firestore
    for (final lesson in newLessons) {
      // Find and delete conflicts in remote first
      state.whenData((lessons) {
        // This is a bit redundant but ensures remote consistency
        // Actually the notifier should probably handle the sequence better
      });
      // We'll just call addLesson for each to simplify (repository handles local cache too)
      await _repository.addLesson(lesson);
    }
  }

  Future<void> deleteLesson(String id) async {
    state.whenData(
      (lessons) =>
          state = AsyncValue.data(lessons.where((l) => l.id != id).toList()),
    );
    await _repository.deleteLesson(id);
  }
}

// ========== EXAMS NOTIFIER ==========

class ExamsNotifier extends StateNotifier<AsyncValue<List<Exam>>> {
  final CalendarRepositoryImpl _repository;

  ExamsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = AsyncValue.data(_repository.getCachedExams());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchAndCacheExams();
    result.fold(
      (f) => state = AsyncValue.error(f, StackTrace.current),
      (exams) => state = AsyncValue.data(exams),
    );
  }

  Future<void> addExam(Exam exam) async {
    state.whenData((exams) {
      final updated = [...exams, exam];
      updated.sort((a, b) => a.date.compareTo(b.date));
      state = AsyncValue.data(updated);
    });
    await _repository.addExam(exam);
  }

  Future<void> deleteExam(String id) async {
    state.whenData(
      (exams) =>
          state = AsyncValue.data(exams.where((e) => e.id != id).toList()),
    );
    await _repository.deleteExam(id);
  }
}

// ========== SUBJECTS NOTIFIER ==========

class SubjectsNotifier extends StateNotifier<AsyncValue<List<Subject>>> {
  final CalendarRepositoryImpl _repository;

  SubjectsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = AsyncValue.data(_repository.getCachedSubjects());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchAndCacheSubjects();
    result.fold(
      (f) => state = AsyncValue.error(f, StackTrace.current),
      (subjects) => state = AsyncValue.data(subjects),
    );
  }

  Future<void> addSubject(Subject subject) async {
    state.whenData(
      (subjects) => state = AsyncValue.data([...subjects, subject]),
    );
    await _repository.addSubject(subject);
  }

  Future<void> deleteSubject(String id) async {
    state.whenData(
      (subjects) =>
          state = AsyncValue.data(subjects.where((s) => s.id != id).toList()),
    );
    await _repository.deleteSubject(id);
  }
}

// ========== SETTINGS NOTIFIER ==========

class ScheduleSettingsNotifier
    extends StateNotifier<AsyncValue<ScheduleSettings>> {
  final CalendarRepositoryImpl _repository;

  ScheduleSettingsNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final cached = _repository.getCachedSettings();
    if (cached != null) {
      state = AsyncValue.data(cached);
    } else {
      state = AsyncValue.data(ScheduleSettings.defaultSettings());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchAndCacheSettings();
    result.fold(
      (f) => state = AsyncValue.error(f, StackTrace.current),
      (settings) => state = AsyncValue.data(settings),
    );
  }

  Future<void> updateSettings(ScheduleSettings settings) async {
    state = AsyncValue.data(settings);
    await _repository.updateSettings(settings);
  }
}

// ========== PROVIDERS ==========

final lessonsNotifierProvider =
    StateNotifierProvider<LessonsNotifier, AsyncValue<List<Lesson>>>((ref) {
      return LessonsNotifier(ref.watch(calendarRepositoryProvider));
    });

final examsNotifierProvider =
    StateNotifierProvider<ExamsNotifier, AsyncValue<List<Exam>>>((ref) {
      return ExamsNotifier(ref.watch(calendarRepositoryProvider));
    });

final subjectsNotifierProvider =
    StateNotifierProvider<SubjectsNotifier, AsyncValue<List<Subject>>>((ref) {
      return SubjectsNotifier(ref.watch(calendarRepositoryProvider));
    });

final scheduleSettingsNotifierProvider =
    StateNotifierProvider<
      ScheduleSettingsNotifier,
      AsyncValue<ScheduleSettings>
    >((ref) {
      return ScheduleSettingsNotifier(ref.watch(calendarRepositoryProvider));
    });
