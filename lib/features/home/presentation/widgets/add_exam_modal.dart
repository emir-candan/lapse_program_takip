import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/domain/entities/exam.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';

class AddExamModal extends ConsumerStatefulWidget {
  const AddExamModal({super.key});

  @override
  ConsumerState<AddExamModal> createState() => _AddExamModalState();
}

class _AddExamModalState extends ConsumerState<AddExamModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _classroomController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay? _selectedTime;
  String? _selectedSubjectId;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      AppModal.showToast(context: context, message: "Lütfen sınav adı girin.");
      return;
    }

    setState(() => _isLoading = true);

    final exam = Exam(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      date: _selectedDate,
      hour: _selectedTime?.hour,
      minute: _selectedTime?.minute,
      subjectId: _selectedSubjectId,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      classroom: _classroomController.text.trim().isEmpty
          ? null
          : _classroomController.text.trim(),
    );

    await ref.read(examsNotifierProvider.notifier).addExam(exam);

    if (mounted) {
      AppModal.showToast(context: context, message: "Sınav eklendi!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final subjectsAsync = ref.watch(subjectsNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    MoonIcons.files_file_24_regular,
                    color: colors.error,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Yeni Sınav Ekle',
                    style: context.moonTypography?.heading.text20.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              // Ders Seçimi
              Text("Ders", style: context.moonTypography?.heading.text14),
              const SizedBox(height: 8),
              subjectsAsync.when(
                loading: () => const Center(child: AppLoader()),
                error: (e, _) => const SizedBox.shrink(),
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return Text(
                      "Önce ders eklemelisiniz.",
                      style: TextStyle(color: colors.error),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(8),
                      color: colors.surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubjectId,
                        isExpanded: true,
                        hint: const Text("Ders Seçiniz"),
                        items: subjects.map((s) {
                          return DropdownMenuItem(
                            value: s.id,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                        s.color.replaceFirst('#', '0xFF'),
                                      ),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(s.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedSubjectId = val;
                            // Auto-fill title if empty? Maybe not, usually exams have specific names.
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              // Sınav adı
              AppTextInput(
                hintText: 'Sınav Başlığı (Örn: 1. Yazılı)',
                controller: _titleController,
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              // Sınav Yeri / Derslik
              AppTextInput(
                hintText: 'Sınav Yeri / Derslik (Örn: B-201)',
                controller: _classroomController,
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              // Tarih ve Saat seçimi - yan yana
              Row(
                children: [
                  // Tarih
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              MoonIcons.time_calendar_24_regular,
                              size: 20,
                              color: colors.error,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tarih',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Saat
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              _selectedTime ??
                              const TimeOfDay(hour: 10, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => _selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              MoonIcons.time_time_24_regular,
                              size: 20,
                              color: colors.brand,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saat',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _selectedTime != null
                                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                            : 'Seçilmedi',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: _selectedTime != null
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _selectedTime != null
                                              ? colors.textPrimary
                                              : colors.textSecondary,
                                        ),
                                      ),
                                      if (_selectedTime != null) ...[
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => _selectedTime = null,
                                          ),
                                          child: Icon(
                                            MoonIcons
                                                .controls_close_small_24_regular,
                                            size: 16,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.tokens.spacingMd),

              // Açıklama
              AppTextInput(
                hintText: 'Notlar (Opsiyonel)',
                controller: _descriptionController,
              ),
              SizedBox(height: AppTheme.tokens.spacingLg),

              // Save button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Sınavı Kaydet',
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
