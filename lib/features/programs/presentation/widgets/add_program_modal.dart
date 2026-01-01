import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/domain/entities/program.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import 'package:uuid/uuid.dart';

class AddProgramModal extends ConsumerStatefulWidget {
  const AddProgramModal({super.key});

  @override
  ConsumerState<AddProgramModal> createState() => _AddProgramModalState();
}

class _AddProgramModalState extends ConsumerState<AddProgramModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedColor = "0xFF079F00"; // Default brand color

  // Pre-defined palette
  final List<String> _colors = [
    "0xFF079F00", // Green (Brand)
    "0xFF3B82F6", // Blue
    "0xFFEF4444", // Red
    "0xFFF59E0B", // Amber
    "0xFF8B5CF6", // Purple
    "0xFFEC4899", // Pink
    "0xFF6366F1", // Indigo
    "0xFF14B8A6", // Teal
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      AppModal.showToast(context: context, message: "Lütfen bir başlık girin.");
      return;
    }

    setState(() => _isLoading = true);

    final program = Program(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      color: _selectedColor,
      description: _descriptionController.text.trim(),
    );

    final result = await ref
        .read(calendarRepositoryProvider)
        .addProgram(program);

    if (mounted) {
      result.fold(
        (failure) {
          AppModal.showToast(context: context, message: failure.message);
          setState(() => _isLoading = false);
        },
        (_) {
          AppModal.showToast(context: context, message: "Program eklendi!");
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Yeni Program Ekle",
                  style: context.moonTypography?.heading.text20.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppTheme.tokens.spacingMd),

                AppTextInput(
                  hintText: "Program Adı (Örn: Ders, Spor)",
                  controller: _titleController,
                ),
                SizedBox(height: AppTheme.tokens.spacingMd),

                AppTextInput(
                  hintText: "Açıklama (Opsiyonel)",
                  controller: _descriptionController,
                ),
                SizedBox(height: AppTheme.tokens.spacingMd),

                Text(
                  "Renk Seçin",
                  style: context.moonTypography?.body.text14.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: AppTheme.tokens.spacingSm),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colors.map((colorHex) {
                    final isSelected = _selectedColor == colorHex;
                    final color = Color(int.parse(colorHex));

                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = colorHex),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: colors.textPrimary, width: 2)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: AppTheme.tokens.spacingLg),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Kaydet",
                    isLoading: _isLoading,
                    onTap: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
