import 'package:hive/hive.dart';
import '../../../../core/constants/hive_type_ids.dart';
import '../../domain/entities/lesson.dart';

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = HiveTypeIds.lesson;

  @override
  Lesson read(BinaryReader reader) {
    return Lesson(
      id: reader.readString(),
      subjectId: reader.readString(),
      dayOfWeek: reader.readInt(),
      slotIndex: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.subjectId);
    writer.writeInt(obj.dayOfWeek);
    writer.writeInt(obj.slotIndex);
  }
}
