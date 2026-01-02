import 'package:hive/hive.dart';
import '../../../../core/constants/hive_type_ids.dart';
import '../../domain/entities/subject.dart';

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = HiveTypeIds.subject;

  @override
  Subject read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final teacher = reader.readString();
    final classroom = reader.readString();
    final ects = reader.readInt();
    final color = reader.readString();

    return Subject(
      id: id,
      name: name,
      teacher: teacher.isEmpty ? null : teacher,
      classroom: classroom.isEmpty ? null : classroom,
      ects: ects == -1 ? null : ects,
      color: color,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.teacher ?? '');
    writer.writeString(obj.classroom ?? '');
    writer.writeInt(obj.ects ?? -1);
    writer.writeString(obj.color);
  }
}
