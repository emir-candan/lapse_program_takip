import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

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
     final colors = AppTheme.colors(context);
    
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        height: AppTheme.tokens.fileUploaderHeight,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
          border: Border.all(
            color: colors.border,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: AppTheme.tokens.fileUploaderIconSize, color: colors.textSecondary),
            SizedBox(height: AppTheme.tokens.spacingSm),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
