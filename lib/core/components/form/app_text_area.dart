import 'package:flutter/material.dart';

/// Standard Multiline Text Input for Lapse.
class AppTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;

  const AppTextArea({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: true,
      ),
    );
  }
}
