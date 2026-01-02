import 'package:hive/hive.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/schedule_settings.dart';

/// Local data source for caching calendar data using Hive
class CalendarLocalDatasource {
  static const String lessonsBoxName = 'lessons_cache';
  static const String examsBoxName = 'exams_cache';
  static const String subjectsBoxName = 'subjects_cache';
  static const String settingsBoxName = 'schedule_settings_cache';

  Box<Lesson>? _lessonsBox;
  Box<Exam>? _examsBox;
  Box<Subject>? _subjectsBox;
  Box<ScheduleSettings>? _settingsBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    _lessonsBox = await Hive.openBox<Lesson>(lessonsBoxName);
    _examsBox = await Hive.openBox<Exam>(examsBoxName);
    _subjectsBox = await Hive.openBox<Subject>(subjectsBoxName);
    _settingsBox = await Hive.openBox<ScheduleSettings>(settingsBoxName);
  }

  // ========== LESSONS ==========

  List<Lesson> getCachedLessons() => _lessonsBox?.values.toList() ?? [];

  Future<void> cacheLessons(List<Lesson> lessons) async {
    await _lessonsBox?.clear();
    for (final lesson in lessons) {
      await _lessonsBox?.put(lesson.id, lesson);
    }
  }

  Future<void> cacheLesson(Lesson lesson) async {
    await _lessonsBox?.put(lesson.id, lesson);
  }

  Future<void> deleteLesson(String lessonId) async {
    await _lessonsBox?.delete(lessonId);
  }

  bool hasLessonCache() => _lessonsBox?.isNotEmpty ?? false;

  // ========== EXAMS ==========

  List<Exam> getCachedExams() => _examsBox?.values.toList() ?? [];

  Future<void> cacheExams(List<Exam> exams) async {
    await _examsBox?.clear();
    for (final exam in exams) {
      await _examsBox?.put(exam.id, exam);
    }
  }

  Future<void> cacheExam(Exam exam) async {
    await _examsBox?.put(exam.id, exam);
  }

  Future<void> deleteExam(String examId) async {
    await _examsBox?.delete(examId);
  }

  bool hasExamCache() => _examsBox?.isNotEmpty ?? false;

  // ========== SUBJECTS ==========

  List<Subject> getCachedSubjects() => _subjectsBox?.values.toList() ?? [];

  Future<void> cacheSubjects(List<Subject> subjects) async {
    await _subjectsBox?.clear();
    for (final subject in subjects) {
      await _subjectsBox?.put(subject.id, subject);
    }
  }

  Future<void> cacheSubject(Subject subject) async {
    await _subjectsBox?.put(subject.id, subject);
  }

  Future<void> deleteSubject(String subjectId) async {
    await _subjectsBox?.delete(subjectId);
  }

  // ========== SETTINGS ==========

  ScheduleSettings? getCachedSettings() => _settingsBox?.get('current');

  Future<void> cacheSettings(ScheduleSettings settings) async {
    await _settingsBox?.put('current', settings);
  }

  // ========== UTILS ==========

  Future<void> clearAll() async {
    await _lessonsBox?.clear();
    await _examsBox?.clear();
    await _subjectsBox?.clear();
    await _settingsBox?.clear();
  }
}
