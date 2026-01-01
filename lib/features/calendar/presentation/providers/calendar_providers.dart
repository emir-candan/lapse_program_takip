import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/program.dart';
import '../../domain/repositories/calendar_repository.dart';

// Repository Provider
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

// Programs List Provider
final programsStreamProvider = StreamProvider.autoDispose<List<Program>>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return repository.getPrograms().map((either) {
    return either.fold(
      (failure) => [], // Return empty list on failure for simplicity in stream
      (programs) => programs,
    );
  });
});

// Selected Date Provider (for UI selection)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Focused Day Provider (for Calendar view month)
final focusedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Events Provider (Fetches events for the currently focused month)
final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  final focusedDay = ref.watch(focusedDayProvider);

  // Calculate start and end of the month
  final start = DateTime(focusedDay.year, focusedDay.month, 1);
  final end = DateTime(focusedDay.year, focusedDay.month + 1, 0, 23, 59, 59);

  return repository.getEvents(start: start, end: end).map((either) {
    return either.fold((failure) => [], (events) => events);
  });
});
