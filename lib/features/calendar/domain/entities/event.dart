import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final String? programId;
  final String? description;

  const Event({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    this.programId,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    startDate,
    endDate,
    isRecurring,
    programId,
    description,
  ];
}
