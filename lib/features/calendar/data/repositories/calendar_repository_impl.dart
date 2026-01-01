import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/program.dart';
import '../../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CalendarRepositoryImpl(this._firestore, this._auth);

  String? get _uid => _auth.currentUser?.uid;

  @override
  Stream<Either<Failure, List<Program>>> getPrograms() {
    if (_uid == null) {
      return Stream.value(const Left(AuthFailure()));
    }

    try {
      return _firestore
          .collection('users')
          .doc(_uid)
          .collection('programs')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            final programs = snapshot.docs.map((doc) {
              final data = doc.data();
              return Program(
                id: doc.id,
                title: data['title'] as String,
                color: data['color'] as String,
                description: data['description'] as String?,
              );
            }).toList();
            return Right<Failure, List<Program>>(programs);
          })
          .handleError((e) {
            return Left<Failure, List<Program>>(ServerFailure(e.toString()));
          });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProgram(Program program) async {
    if (_uid == null) return const Left(AuthFailure());

    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('programs')
          .doc(program.id)
          .set({
            'title': program.title,
            'color': program.color,
            'description': program.description,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 3));
      return const Right(unit);
    } on TimeoutException {
      // Hybrid Strategy: If server doesn't ack in 3s, treat as success (Optimistic)
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProgram(String id) async {
    if (_uid == null) return const Left(AuthFailure());

    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('programs')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 3));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> getEvents({
    required DateTime start,
    required DateTime end,
  }) {
    if (_uid == null) {
      return Stream.value(const Left(AuthFailure()));
    }

    try {
      final rangeStream = _firestore
          .collection('users')
          .doc(_uid)
          .collection('events')
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .snapshots();

      final recurringStream = _firestore
          .collection('users')
          .doc(_uid)
          .collection('events')
          .where('isRecurring', isEqualTo: true)
          .snapshots();

      return Rx.combineLatest2(rangeStream, recurringStream, (
        QuerySnapshot rangeSnap,
        QuerySnapshot recurringSnap,
      ) {
        final rangeEvents = rangeSnap.docs.map((doc) => _docToEvent(doc));
        final recurringEvents = recurringSnap.docs.map(
          (doc) => _docToEvent(doc),
        );

        final allEvents = <String, Event>{};

        for (var event in rangeEvents) {
          allEvents[event.id] = event;
        }
        for (var event in recurringEvents) {
          allEvents[event.id] = event;
        }

        final list = allEvents.values.toList();
        list.sort((a, b) => a.startDate.compareTo(b.startDate));

        return Right<Failure, List<Event>>(list);
      }).handleError((e) {
        return Left<Failure, List<Event>>(ServerFailure(e.toString()));
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  Event _docToEvent(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isRecurring: data['isRecurring'] as bool? ?? false,
      programId: data['programId'] as String?,
      description: data['description'] as String?,
    );
  }

  @override
  Future<Either<Failure, Unit>> addEvent(Event event) async {
    if (_uid == null) return const Left(AuthFailure());

    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('events')
          .doc(event.id)
          .set({
            'title': event.title,
            'startDate': Timestamp.fromDate(event.startDate),
            'endDate': Timestamp.fromDate(event.endDate),
            'isRecurring': event.isRecurring,
            'programId': event.programId,
            'description': event.description,
            'status': 'pending',
          })
          .timeout(const Duration(seconds: 3));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEvent(String id) async {
    if (_uid == null) return const Left(AuthFailure());

    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('events')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 3));
      return const Right(unit);
    } on TimeoutException {
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
