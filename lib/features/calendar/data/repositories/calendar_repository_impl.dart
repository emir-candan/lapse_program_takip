import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/exam.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/schedule_settings.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_local_datasource.dart';

/// Offline-first implementation of CalendarRepository
class CalendarRepositoryImpl implements CalendarRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final CalendarLocalDatasource _localDatasource;

  CalendarRepositoryImpl(this._firestore, this._auth, this._localDatasource);

  String? get _uid => _auth.currentUser?.uid;

  // ========== LESSONS ==========

  @override
  List<Lesson> getCachedLessons() => _localDatasource.getCachedLessons();

  @override
  Future<Either<Failure, List<Lesson>>> fetchAndCacheLessons() async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('lessons')
          .get();

      final lessons = snapshot.docs.map((doc) {
        final data = doc.data();
        return Lesson(
          id: doc.id,
          subjectId: data['subjectId'] as String,
          dayOfWeek: data['dayOfWeek'] as int,
          slotIndex: data['slotIndex'] as int,
        );
      }).toList();

      await _localDatasource.cacheLessons(lessons);
      return Right(lessons);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addLesson(Lesson lesson) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.cacheLesson(lesson);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('lessons')
          .doc(lesson.id)
          .set({
            'subjectId': lesson.subjectId,
            'dayOfWeek': lesson.dayOfWeek,
            'slotIndex': lesson.slotIndex,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLesson(String id) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.deleteLesson(id);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('lessons')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== EXAMS ==========

  @override
  List<Exam> getCachedExams() => _localDatasource.getCachedExams();

  @override
  Future<Either<Failure, List<Exam>>> fetchAndCacheExams() async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('exams')
          .orderBy('date')
          .get();

      final exams = snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp;
        return Exam(
          id: doc.id,
          title: data['title'] as String,
          date: timestamp.toDate(),
          hour: data['hour'] as int?,
          minute: data['minute'] as int?,
          description: data['description'] as String?,
        );
      }).toList();

      await _localDatasource.cacheExams(exams);
      return Right(exams);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addExam(Exam exam) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.cacheExam(exam);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('exams')
          .doc(exam.id)
          .set({
            'title': exam.title,
            'date': Timestamp.fromDate(exam.date),
            'hour': exam.hour,
            'minute': exam.minute,
            'description': exam.description,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExam(String id) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.deleteExam(id);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('exams')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== SUBJECTS ==========

  @override
  List<Subject> getCachedSubjects() => _localDatasource.getCachedSubjects();

  @override
  Future<Either<Failure, List<Subject>>> fetchAndCacheSubjects() async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('subjects')
          .get();

      final subjects = snapshot.docs.map((doc) {
        final data = doc.data();
        return Subject(
          id: doc.id,
          name: data['name'] as String,
          teacher: data['teacher'] as String?,
          classroom: data['classroom'] as String?,
          ects: data['ects'] as int?,
          color: data['color'] as String,
        );
      }).toList();

      await _localDatasource.cacheSubjects(subjects);
      return Right(subjects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSubject(Subject subject) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.cacheSubject(subject);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('subjects')
          .doc(subject.id)
          .set({
            'name': subject.name,
            'teacher': subject.teacher,
            'classroom': subject.classroom,
            'ects': subject.ects,
            'color': subject.color,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSubject(String id) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.deleteSubject(id);
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('subjects')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== SETTINGS ==========

  @override
  ScheduleSettings? getCachedSettings() => _localDatasource.getCachedSettings();

  @override
  Future<Either<Failure, ScheduleSettings>> fetchAndCacheSettings() async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      final doc = await _firestore.collection('users').doc(_uid).get();

      final settingsData =
          doc.data()?['scheduleSettings'] as Map<String, dynamic>?;

      final settings = settingsData != null
          ? ScheduleSettings(
              startHour: settingsData['startHour'] as int,
              startMinute: settingsData['startMinute'] as int,
              endHour: settingsData['endHour'] as int? ?? 16,
              endMinute: settingsData['endMinute'] as int? ?? 0,
              classDuration: settingsData['classDuration'] as int,
              breakDuration: settingsData['breakDuration'] as int,
              lunchBreakStartHour: settingsData['lunchBreakStartHour'] as int?,
              lunchBreakStartMinute:
                  settingsData['lunchBreakStartMinute'] as int?,
              lunchBreakEndHour: settingsData['lunchBreakEndHour'] as int?,
              lunchBreakEndMinute: settingsData['lunchBreakEndMinute'] as int?,
            )
          : ScheduleSettings.defaultSettings();

      await _localDatasource.cacheSettings(settings);
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSettings(
    ScheduleSettings settings,
  ) async {
    if (_uid == null) return const Left(AuthFailure());
    try {
      await _localDatasource.cacheSettings(settings);
      await _firestore
          .collection('users')
          .doc(_uid)
          .update({
            'scheduleSettings': {
              'startHour': settings.startHour,
              'startMinute': settings.startMinute,
              'endHour': settings.endHour,
              'endMinute': settings.endMinute,
              'classDuration': settings.classDuration,
              'breakDuration': settings.breakDuration,
              'lunchBreakStartHour': settings.lunchBreakStartHour,
              'lunchBreakStartMinute': settings.lunchBreakStartMinute,
              'lunchBreakEndHour': settings.lunchBreakEndHour,
              'lunchBreakEndMinute': settings.lunchBreakEndMinute,
            },
          })
          .timeout(const Duration(seconds: 5));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== UTILS ==========

  @override
  bool hasCachedData() =>
      _localDatasource.hasLessonCache() || _localDatasource.hasExamCache();

  @override
  Future<void> forceRefresh() async {
    await fetchAndCacheLessons();
    await fetchAndCacheExams();
    await fetchAndCacheSubjects();
    await fetchAndCacheSettings();
  }
}
