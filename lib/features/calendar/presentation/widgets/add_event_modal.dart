import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/domain/entities/event.dart';
import '../../../calendar/domain/entities/program.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import 'package:uuid/uuid.dart';

class AddEventModal extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final Event? eventToEdit;

  const AddEventModal({super.key, required this.initialDate, this.eventToEdit});

  @override
  ConsumerState<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends ConsumerState<AddEventModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  Program? _selectedProgram;
  bool _isRecurring = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      final e = widget.eventToEdit!;
      _titleController.text = e.title;
      _descriptionController.text = e.description ?? "";
      _selectedDate = e.startDate;
      _isRecurring = e.isRecurring;
      // Program selection happens after data load or we try to match id here if we had list.
      // Since we rely on AsyncValue in build, we will handle initial program selection logic there or via a post-frame callback if strictly needed.
      // However, for simplicity in this stream-based UI, we can try to find it in build or just leave it.
      // Better approach: We wait for stream in build.
    } else {
      _selectedDate = widget.initialDate;
    }
  }

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

    final eventId = widget.eventToEdit?.id ?? const Uuid().v4();

    final event = Event(
      id: eventId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _selectedDate,
      endDate: _selectedDate.add(const Duration(hours: 1)),
      isRecurring: _isRecurring,
      programId: _selectedProgram?.id,
    );

    final result = await ref.read(calendarRepositoryProvider).addEvent(event);

    if (mounted) {
      result.fold(
        (failure) {
          AppModal.showToast(context: context, message: failure.message);
          setState(() => _isLoading = false);
        },
        (_) {
          final msg = widget.eventToEdit == null
              ? "Etkinlik eklendi!"
              : "Etkinlik güncellendi!";
          AppModal.showToast(context: context, message: msg);
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final programsAsync = ref.watch(programsStreamProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.eventToEdit == null
                ? "Yeni Etkinlik Ekle"
                : "Etkinliği Düzenle",
            style: context.moonTypography?.heading.text20.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),

          // Title
          AppTextInput(
            hintText: "Etkinlik Başlığı (Örn: Sınav, Toplantı)",
            controller: _titleController,
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),

          // Program Selection
          programsAsync.when(
            data: (programs) {
              // Pre-select program if editing and not yet selected
              if (widget.eventToEdit != null &&
                  widget.eventToEdit!.programId != null &&
                  _selectedProgram == null) {
                try {
                  final p = programs.firstWhere(
                    (p) => p.id == widget.eventToEdit!.programId,
                  );
                  _selectedProgram = p;
                } catch (_) {}
              }

              return AppDropdown<Program>(
                hintText: "Program Seçiniz (Opsiyonel)",
                value: _selectedProgram,
                items: programs.map((program) {
                  final color = Color(int.parse(program.color));
                  return DropdownMenuItem(
                    value: program,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          program.title,
                          style: context.moonTypography?.body.text14.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedProgram = val),
              );
            },
            error: (_, __) => const SizedBox(),
            loading: () => const LinearProgressIndicator(),
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),

          // Date Picker
          AppDatePicker(
            label: "Tarih",
            value: _selectedDate,
            onChanged: (date) => setState(() => _selectedDate = date),
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),

          // Description
          AppTextInput(
            hintText: "Notlar (Opsiyonel)",
            controller: _descriptionController,
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),

          // Recurring Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Her Yıl Tekrarla",
                style: context.moonTypography?.body.text14.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              MoonSwitch(
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
                activeTrackColor: colors.brand,
              ),
            ],
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
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
