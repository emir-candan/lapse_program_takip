import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppCodeInput extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;

  const AppCodeInput({
    super.key,
    this.length = 4,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // File list: moon_ui_code_input_field.dart
    // Class likely MoonCodeInput or MoonCodeInputField or MoonAuthCode
    // Trying MoonCodeInput.
    return MoonCodeInput(
      codeLength: length,
      onCompleted: onCompleted,
      // styling...
    );
  }
}
