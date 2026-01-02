import 'package:hive/hive.dart';
import '../../../../core/constants/hive_type_ids.dart';
import '../../domain/entities/schedule_settings.dart';

class ScheduleSettingsAdapter extends TypeAdapter<ScheduleSettings> {
  @override
  final int typeId = HiveTypeIds.scheduleSettings;

  @override
  ScheduleSettings read(BinaryReader reader) {
    return ScheduleSettings(
      startHour: reader.readInt(),
      startMinute: reader.readInt(),
      endHour: reader.readInt(),
      endMinute: reader.readInt(),
      classDuration: reader.readInt(),
      breakDuration: reader.readInt(),
      lunchBreakStartHour: reader.readInt().let((v) => v == -1 ? null : v),
      lunchBreakStartMinute: reader.readInt().let((v) => v == -1 ? null : v),
      lunchBreakEndHour: reader.readInt().let((v) => v == -1 ? null : v),
      lunchBreakEndMinute: reader.readInt().let((v) => v == -1 ? null : v),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleSettings obj) {
    writer.writeInt(obj.startHour);
    writer.writeInt(obj.startMinute);
    writer.writeInt(obj.endHour);
    writer.writeInt(obj.endMinute);
    writer.writeInt(obj.classDuration);
    writer.writeInt(obj.breakDuration);
    writer.writeInt(obj.lunchBreakStartHour ?? -1);
    writer.writeInt(obj.lunchBreakStartMinute ?? -1);
    writer.writeInt(obj.lunchBreakEndHour ?? -1);
    writer.writeInt(obj.lunchBreakEndMinute ?? -1);
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
