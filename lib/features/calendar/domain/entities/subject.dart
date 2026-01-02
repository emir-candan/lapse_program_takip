import 'package:equatable/equatable.dart';

/// Kullanıcının oluşturduğu bir ders tanımlaması (Örn: Matematik, Fizik)
class Subject extends Equatable {
  final String id;
  final String name;
  final String? teacher;
  final String? classroom;
  final int? ects;
  final String color; // Hex string

  const Subject({
    required this.id,
    required this.name,
    this.teacher,
    this.classroom,
    this.ects,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, teacher, classroom, ects, color];
}
