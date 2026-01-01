import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import 'package:lapse/features/calendar/domain/entities/event.dart';
import 'package:lapse/features/calendar/domain/entities/program.dart';

abstract class CalendarRepository {
  // Programs
  Stream<Either<Failure, List<Program>>> getPrograms();
  Future<Either<Failure, Unit>> addProgram(Program program);
  Future<Either<Failure, Unit>> deleteProgram(String id);

  // Events
  Stream<Either<Failure, List<Event>>> getEvents({
    required DateTime start,
    required DateTime end,
  });
  Future<Either<Failure, Unit>> addEvent(Event event);
  Future<Either<Failure, Unit>> deleteEvent(String id);
}
