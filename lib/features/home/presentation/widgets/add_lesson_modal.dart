import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../calendar/domain/entities/lesson.dart';
import '../../../calendar/domain/entities/subject.dart';
import '../../../calendar/domain/entities/schedule_settings.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import 'add_subject_modal.dart';

class AddLessonModal extends ConsumerStatefulWidget {
  final int? initialSlot;
  final int? initialDay;

  const AddLessonModal({super.key, this.initialSlot, this.initialDay});

  @override
  ConsumerState<AddLessonModal> createState() => _AddLessonModalState();
}

class _AddLessonModalState extends ConsumerState<AddLessonModal> {
  String? _selectedSubjectId;
  late int _selectedDay;
  // Map<DayIndex, Set<SlotIndex>>
  final Map<int, Set<int>> _selectedSlots = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? 1;
    if (widget.initialSlot != null) {
      // If opened from a specific slot, pre-select it for that day
      _selectedSlots[_selectedDay] = {widget.initialSlot!};
    }
  }

  Future<void> _save() async {
    if (_selectedSubjectId == null) {
      AppModal.showToast(context: context, message: "Lütfen bir ders seçin.");
      return;
    }

    if (_selectedSlots.isEmpty ||
        _selectedSlots.values.every((s) => s.isEmpty)) {
      AppModal.showToast(
        context: context,
        message: "Lütfen en az bir saat seçin.",
      );
      return;
    }

    setState(() => _isLoading = true);

    final List<Lesson> lessons = [];

    _selectedSlots.forEach((day, slots) {
      for (final slot in slots) {
        lessons.add(
          Lesson(
            id: const Uuid().v4(),
            subjectId: _selectedSubjectId!,
            dayOfWeek: day,
            slotIndex: slot,
          ),
        );
      }
    });

    await ref.read(lessonsNotifierProvider.notifier).addLessons(lessons);

    if (mounted) {
      AppModal.showToast(
        context: context,
        message: "${lessons.length} ders programa eklendi!",
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final subjectsAsync = ref.watch(subjectsNotifierProvider);
    final settingsAsync = ref.watch(scheduleSettingsNotifierProvider);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);

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
        child: subjectsAsync.when(
          loading: () => const Center(child: AppLoader()),
          error: (e, _) => Center(child: Text('Hata: $e')),
          data: (subjects) {
            if (subjects.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppAlert(
                    title: "Henüz tanımlanmış bir dersiniz yok.",
                    body: "Önce ders tanımlamalısınız.",
                  ),
                  SizedBox(height: AppTheme.tokens.spacingMd),
                  AppButton(
                    label: "Ders Tanımla",
                    onTap: () {
                      Navigator.pop(context);
                      AppModal.show(
                        context: context,
                        child: const AddSubjectModal(),
                      );
                    },
                  ),
                ],
              );
            }

            return settingsAsync.when(
              loading: () => const Center(child: AppLoader()),
              error: (e, _) => Center(child: Text('Ayarlar yüklenemedi: $e')),
              data: (settings) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dersi Programa Yerleştir',
                        style: context.moonTypography?.heading.text20,
                      ),
                      SizedBox(height: AppTheme.tokens.spacingMd),

                      // Ders Seçimi
                      Text(
                        'Ders Seç',
                        style: context.moonTypography?.body.text12.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppDropdown<String>(
                        value: _selectedSubjectId,
                        hintText: "Ders seçin",
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
                                SizedBox(width: AppTheme.tokens.spacingSm),
                                Text(s.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedSubjectId = val),
                      ),
                      SizedBox(height: AppTheme.tokens.spacingMd),

                      // Gün Seçimi
                      Text(
                        'Gün',
                        style: context.moonTypography?.body.text12.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppTheme.tokens.spacingSm),
                      SizedBox(
                        height: 48,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(7, (index) {
                              final dayNum = index + 1;
                              final isSelected = _selectedDay == dayNum;
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: AppTheme.tokens.spacingSm,
                                ),
                                child: ChoiceChip(
                                  label: Text(
                                    AppConstants.dayNamesShort[index],
                                  ),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    setState(() {
                                      _selectedDay = dayNum;
                                      // Gün değişince seçimleri koruyoruz (Multi-day support)
                                    });
                                  },
                                  selectedColor: colors.brand,
                                  backgroundColor: colors.surface,
                                  side: BorderSide(
                                    color: isSelected
                                        ? colors.brand
                                        : colors.border,
                                  ),
                                  labelStyle: context
                                      .moonTypography
                                      ?.body
                                      .text12
                                      .copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : colors.textPrimary,
                                      ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: AppTheme.tokens.spacingMd),

                      // Slot Seçimi
                      Text(
                        'Ders Saati (Birden fazla seçebilirsiniz)',
                        style: context.moonTypography?.body.text12.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppTheme.tokens.spacingSm),
                      lessonsAsync.when(
                        loading: () => const AppLoader(),
                        error: (e, _) => Text("Hata: $e"),
                        data: (lessons) => _buildSlotPicker(
                          settings,
                          lessons,
                          subjects,
                          colors,
                        ),
                      ),

                      SizedBox(height: AppTheme.tokens.spacingLg),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Programa Ekle',
                          isLoading: _isLoading,
                          onTap: _save,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlotPicker(
    ScheduleSettings settings,
    List<Lesson> lessons,
    List<Subject> subjects,
    AppColors colors,
  ) {
    final timings = settings.calculateSlotTimings();
    final dayLessons = lessons
        .where((l) => l.dayOfWeek == _selectedDay)
        .toList();

    final currentDaySlots = _selectedSlots[_selectedDay] ?? {};

    return Wrap(
      spacing: AppTheme.tokens.spacingSm,
      runSpacing: AppTheme.tokens.spacingSm,
      children: List.generate(timings.length, (index) {
        final isSelected = currentDaySlots.contains(index);
        final slot = timings[index];
        final timeRange =
            '${_formatMinutes(slot.start)} - ${_formatMinutes(slot.end)}';

        final existingLesson = dayLessons.cast<Lesson?>().firstWhere(
          (l) => l?.slotIndex == index,
          orElse: () => null,
        );

        final existingSubject = existingLesson != null
            ? subjects.cast<Subject?>().firstWhere(
                (s) => s?.id == existingLesson.subjectId,
                orElse: () => null,
              )
            : null;

        final isOccupied = existingLesson != null;

        return GestureDetector(
          onTap: isOccupied
              ? null // Doluysa dokunulamaz
              : () {
                  setState(() {
                    final slots = _selectedSlots[_selectedDay] ?? {};
                    if (isSelected) {
                      slots.remove(index);
                    } else {
                      slots.add(index);
                    }
                    _selectedSlots[_selectedDay] = slots;
                  });
                },
          child: Container(
            constraints: const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colors.brand : colors.surface,
              border: Border.all(
                color: isSelected ? colors.brand : colors.border,
              ),
              borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
            ),
            child: SizedBox(
              height: 48,
              child: Opacity(
                opacity: isOccupied ? 0.5 : 1.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}. Ders',
                          style: context.moonTypography?.body.text10.copyWith(
                            color: isSelected
                                ? Colors.white
                                : colors.textSecondary,
                          ),
                        ),
                        if (isOccupied) ...[
                          SizedBox(width: AppTheme.tokens.spacingXs),
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 10,
                            color: colors.error,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      timeRange,
                      style: context.moonTypography?.body.text12.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : colors.textPrimary,
                      ),
                    ),
                    if (existingSubject != null)
                      Text(
                        existingSubject.name,
                        style: context.moonTypography?.body.text10.copyWith(
                          color: isSelected
                              ? Colors.white70
                              : colors.textSecondary.withValues(alpha: 0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatMinutes(int minutes) {
    final h = (minutes / 60).floor();
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
