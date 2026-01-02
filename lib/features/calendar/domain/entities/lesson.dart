import 'package:equatable/equatable.dart';

/// Haftalık ders programındaki bir ders slotu
class Lesson extends Equatable {
  final String id;
  final String subjectId; // Subject entity'sine bağlı
  final int dayOfWeek; // 1=Pazartesi, 7=Pazar
  final int slotIndex; // Time slot index (0'dan başlar)

  const Lesson({
    required this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.slotIndex,
  });

  @override
  List<Object?> get props => [id, subjectId, dayOfWeek, slotIndex];
}
