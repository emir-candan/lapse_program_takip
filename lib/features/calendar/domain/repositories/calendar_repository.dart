import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/lesson.dart';
import '../entities/exam.dart';
import '../entities/subject.dart';
import '../entities/schedule_settings.dart';

/// Abstract repository interface for calendar data
abstract class CalendarRepository {
  // Lessons
  List<Lesson> getCachedLessons();
  Future<Either<Failure, List<Lesson>>> fetchAndCacheLessons();
  Future<Either<Failure, Unit>> addLesson(Lesson lesson);
  Future<Either<Failure, Unit>> deleteLesson(String id);

  // Exams
  List<Exam> getCachedExams();
  Future<Either<Failure, List<Exam>>> fetchAndCacheExams();
  Future<Either<Failure, Unit>> addExam(Exam exam);
  Future<Either<Failure, Unit>> deleteExam(String id);

  // Subjects
  List<Subject> getCachedSubjects();
  Future<Either<Failure, List<Subject>>> fetchAndCacheSubjects();
  Future<Either<Failure, Unit>> addSubject(Subject subject);
  Future<Either<Failure, Unit>> deleteSubject(String id);

  // Settings
  ScheduleSettings? getCachedSettings();
  Future<Either<Failure, ScheduleSettings>> fetchAndCacheSettings();
  Future<Either<Failure, Unit>> updateSettings(ScheduleSettings settings);

  // Utils
  bool hasCachedData();
  Future<void> forceRefresh();
}
