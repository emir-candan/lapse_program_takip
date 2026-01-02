import 'package:hive/hive.dart';
import '../../../../core/constants/hive_type_ids.dart';
import '../../domain/entities/exam.dart';

class ExamAdapter extends TypeAdapter<Exam> {
  @override
  final int typeId = HiveTypeIds.exam;

  @override
  Exam read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final dateMs = reader.readInt();
    final hourRaw = reader.readInt();
    final minuteRaw = reader.readInt();
    final subjectIdRaw = reader.readString();
    final descriptionRaw = reader.readString();
    final classroomRaw = reader.readString();

    return Exam(
      id: id,
      title: title,
      date: DateTime.fromMillisecondsSinceEpoch(dateMs),
      hour: hourRaw == -1 ? null : hourRaw,
      minute: minuteRaw == -1 ? null : minuteRaw,
      subjectId: subjectIdRaw.isEmpty ? null : subjectIdRaw,
      description: descriptionRaw.isEmpty ? null : descriptionRaw,
      classroom: classroomRaw.isEmpty ? null : classroomRaw,
    );
  }

  @override
  void write(BinaryWriter writer, Exam obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeInt(obj.hour ?? -1);
    writer.writeInt(obj.minute ?? -1);
    writer.writeString(obj.subjectId ?? '');
    writer.writeString(obj.description ?? '');
    writer.writeString(obj.classroom ?? '');
  }
}
