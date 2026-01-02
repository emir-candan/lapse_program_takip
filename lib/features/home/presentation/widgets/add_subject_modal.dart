import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/domain/entities/subject.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';

class AddSubjectModal extends ConsumerStatefulWidget {
  const AddSubjectModal({super.key});

  @override
  ConsumerState<AddSubjectModal> createState() => _AddSubjectModalState();
}

class _AddSubjectModalState extends ConsumerState<AddSubjectModal> {
  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();
  final _classroomController = TextEditingController();
  final _ectsController = TextEditingController();

  String _selectedColorHex = '#4CAF50'; // Default green
  bool _isLoading = false;

  final List<String> _colors = [
    '#F44336',
    '#E91E63',
    '#9C27B0',
    '#673AB7',
    '#3F51B5',
    '#2196F3',
    '#03A9F4',
    '#00BCD4',
    '#009688',
    '#8BC34A',
    '#CDDC39',
    '#FFEB3B',
    '#FFC107',
    '#FF9800',
    '#FF5722',
    '#795548',
    '#9E9E9E',
    '#607D8B',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _classroomController.dispose();
    _ectsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      AppModal.showToast(context: context, message: "Lütfen ders adı girin.");
      return;
    }

    setState(() => _isLoading = true);

    final subject = Subject(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      teacher: _teacherController.text.trim().isEmpty
          ? null
          : _teacherController.text.trim(),
      classroom: _classroomController.text.trim().isEmpty
          ? null
          : _classroomController.text.trim(),
      ects: int.tryParse(_ectsController.text),
      color: _selectedColorHex,
    );

    await ref.read(subjectsNotifierProvider.notifier).addSubject(subject);

    if (mounted) {
      AppModal.showToast(context: context, message: "Ders tanımlandı!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.tokens.radiusLg),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yeni Ders Tanımla',
                style: context.moonTypography?.heading.text20.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              AppTextInput(
                hintText: 'Ders Adı (Zorunlu)',
                controller: _nameController,
              ),
              SizedBox(height: AppTheme.tokens.spacingSm),

              AppTextInput(
                hintText: 'Hoca (Opsiyonel)',
                controller: _teacherController,
              ),
              SizedBox(height: AppTheme.tokens.spacingSm),

              Row(
                children: [
                  Expanded(
                    child: AppTextInput(
                      hintText: 'Derslik (Opsiyonel)',
                      controller: _classroomController,
                    ),
                  ),
                  SizedBox(width: AppTheme.tokens.spacingSm),
                  Expanded(
                    child: AppTextInput(
                      hintText: 'AKTS (Opsiyonel)',
                      controller: _ectsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              Text(
                'Renk Seçimi',
                style: context.moonTypography?.body.text12.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: AppTheme.tokens.spacingSm),
              Wrap(
                spacing: AppTheme.tokens.spacingSm,
                runSpacing: AppTheme.tokens.spacingSm,
                children: _colors.map((hex) {
                  final isSelected = _selectedColorHex == hex;
                  final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = hex),
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
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: AppTheme.tokens.spacingMd,
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
                  label: 'Tanımla',
                  isLoading: _isLoading,
                  onTap: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
