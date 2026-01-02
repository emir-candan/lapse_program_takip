import 'package:equatable/equatable.dart';

/// Okulun zaman çizelgesi ayarları
class ScheduleSettings extends Equatable {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int classDuration; // Dakika
  final int breakDuration; // Dakika
  final int? lunchBreakStartHour;
  final int? lunchBreakStartMinute;
  final int? lunchBreakEndHour;
  final int? lunchBreakEndMinute;

  const ScheduleSettings({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.classDuration,
    required this.breakDuration,
    this.lunchBreakStartHour,
    this.lunchBreakStartMinute,
    this.lunchBreakEndHour,
    this.lunchBreakEndMinute,
  });

  /// Default settings (09:00 start, 16:00 end, 40 min class, 10 min break)
  factory ScheduleSettings.defaultSettings() {
    return const ScheduleSettings(
      startHour: 9,
      startMinute: 0,
      endHour: 16,
      endMinute: 0,
      classDuration: 40,
      breakDuration: 10,
    );
  }

  @override
  List<Object?> get props => [
    startHour,
    startMinute,
    endHour,
    endMinute,
    classDuration,
    breakDuration,
    lunchBreakStartHour,
    lunchBreakStartMinute,
    lunchBreakEndHour,
    lunchBreakEndMinute,
  ];

  /// Toplam ders saati sayısını hesaplar
  int get slotCount => calculateSlotTimings().length;

  /// Tüm slotların başlangıç ve bitiş zamanlarını (dakika cinsinden) hesaplar
  List<({int start, int end})> calculateSlotTimings() {
    final List<({int start, int end})> slots = [];

    final dayStart = startHour * 60 + startMinute;
    final dayEnd = endHour * 60 + endMinute;

    final lunchStart =
        (lunchBreakStartHour != null && lunchBreakStartMinute != null)
        ? lunchBreakStartHour! * 60 + lunchBreakStartMinute!
        : null;
    final lunchEnd = (lunchBreakEndHour != null && lunchBreakEndMinute != null)
        ? lunchBreakEndHour! * 60 + lunchBreakEndMinute!
        : null;

    var currentMinutes = dayStart;

    while (currentMinutes + classDuration <= dayEnd) {
      final slotStart = currentMinutes;
      final slotEnd = currentMinutes + classDuration;

      // Öğle arası çakışma kontrolü
      if (lunchStart != null && lunchEnd != null) {
        // Eğer ders öğle arası içine giriyorsa veya öğle arasını kapsıyorsa
        if ((slotStart >= lunchStart && slotStart < lunchEnd) ||
            (slotEnd > lunchStart && slotEnd <= lunchEnd)) {
          currentMinutes = lunchEnd;
          continue;
        }
      }

      slots.add((start: slotStart, end: slotEnd));

      // Bir sonraki slotun başlangıcı: bitiş + ders arası
      currentMinutes = slotEnd + breakDuration;
    }

    return slots;
  }
}
