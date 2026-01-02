import 'package:equatable/equatable.dart';

/// Tek seferlik sınav
class Exam extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final int? hour;
  final int? minute;
  final String? subjectId; // İlişkili ders (Subject)
  final String? description;

  const Exam({
    required this.id,
    required this.title,
    required this.date,
    this.hour,
    this.minute,
    this.subjectId,
    this.description,
  });

  /// Saat formatı: "14:00" veya null
  String? get timeString {
    if (hour == null) return null;
    return '${hour.toString().padLeft(2, '0')}:${(minute ?? 0).toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    hour,
    minute,
    subjectId,
    description,
  ];
}
