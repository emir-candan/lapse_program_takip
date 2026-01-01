import 'package:equatable/equatable.dart';

class Program extends Equatable {
  final String id;
  final String title;
  final String color;
  final String? description;

  const Program({
    required this.id,
    required this.title,
    required this.color,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, color, description];
}
