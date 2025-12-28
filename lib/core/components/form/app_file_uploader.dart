import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppFileUploader extends StatelessWidget {
  final String label;
  final VoidCallback? onUpload;

  const AppFileUploader({
    super.key,
    this.label = "Dosya Yükle",
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    // moon_ui_file_uploader.dart
    return MoonFileUploader(
      label: Text(label),
      onTap: onUpload,
    );
  }
}
