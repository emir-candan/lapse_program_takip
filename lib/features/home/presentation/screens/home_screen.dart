import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../../calendar/domain/entities/lesson.dart';
import '../../../calendar/domain/entities/subject.dart';
import '../../../calendar/domain/entities/schedule_settings.dart';
import '../../../calendar/domain/entities/exam.dart';
import '../widgets/add_lesson_modal.dart';

// Provider for selected day
final selectedDayProvider = StateProvider<int>((ref) => DateTime.now().weekday);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final subjectsAsync = ref.watch(subjectsNotifierProvider);
    final settingsAsync = ref.watch(scheduleSettingsNotifierProvider);
    final examsAsync = ref.watch(examsNotifierProvider);
    final selectedDay = ref.watch(selectedDayProvider);

    return AppPageLayout(
      title: "Ana Sayfa",
      scrollable: false,
      padding: EdgeInsets.zero,
      child: subjectsAsync.when(
        loading: () => const Center(child: AppLoader()),
        error: (e, _) => Center(child: Text("Hata: $e")),
        data: (subjects) => settingsAsync.when(
          loading: () => const Center(child: AppLoader()),
          error: (e, _) => Center(child: Text("Hata: $e")),
          data: (settings) => lessonsAsync.when(
            loading: () => const Center(child: AppLoader()),
            error: (e, _) => Center(child: Text("Hata: $e")),
            data: (lessons) {
              final dayLessons = lessons
                  .where((l) => l.dayOfWeek == selectedDay)
                  .toList();
              dayLessons.sort((a, b) => a.slotIndex.compareTo(b.slotIndex));

              final exams = examsAsync.valueOrNull ?? [];
              final now = DateTime.now();
              final upcomingExams = exams
                  .where(
                    (e) =>
                        e.date.isAfter(now.subtract(const Duration(days: 1))) &&
                        e.date.isBefore(now.add(const Duration(days: 7))),
                  )
                  .toList();

              return Column(
                children: [
                  _buildDaySelector(context, ref, colors, lessons, selectedDay),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.tokens.spacingMd,
                      vertical: AppTheme.tokens.spacingSm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppConstants.dayNames[selectedDay - 1],
                          style: context.moonTypography?.heading.text18
                              .copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        _buildExamStatusAction(context, ref, colors),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildLessonList(
                      context,
                      ref,
                      colors,
                      dayLessons,
                      subjects,
                      settings,
                      selectedDay,
                    ),
                  ),
                  if (upcomingExams.isNotEmpty)
                    _buildExamsPreview(context, colors, upcomingExams, now),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(
    BuildContext context,
    WidgetRef ref,
    AppColors colors,
    List<Lesson> lessons,
    int selectedDay,
  ) {
    final today = DateTime.now().weekday;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppTheme.tokens.spacingSm),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final dayNum = index + 1;
          final isSelected = selectedDay == dayNum;
          final isToday = dayNum == today;

          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(selectedDayProvider.notifier).state = dayNum,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppTheme.tokens.spacingXs / 2,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: AppTheme.tokens.spacingSm + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.brand : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
                  border: Border.all(
                    color: isToday && !isSelected
                        ? colors.brand
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      AppConstants.dayNamesShort[index],
                      style: context.moonTypography?.body.text12.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? colors.brand : colors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLessonList(
    BuildContext context,
    WidgetRef ref,
    AppColors colors,
    List<Lesson> dayLessons,
    List<Subject> subjects,
    ScheduleSettings settings,
    int selectedDay,
  ) {
    if (settings.slotCount == 0) {
      return AppEmptyState(
        icon: MoonIcons.generic_info_32_regular,
        message: "Program ayarlanmamış.",
      );
    }

    final timings = settings.calculateSlotTimings();
    final colors = AppTheme.colors(context);

    // Lunch break gap detection
    final int? lunchBreakIndex;
    int? detectedIndex;
    for (int i = 1; i < timings.length; i++) {
      final gap = timings[i].start - timings[i - 1].end;
      if (gap > settings.breakDuration) {
        detectedIndex = i;
        break;
      }
    }
    lunchBreakIndex = detectedIndex;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.tokens.spacingMd),
      itemCount: timings.length + (lunchBreakIndex != null ? 1 : 0),
      itemBuilder: (context, index) {
        // Adjust index if lunch break is present
        int actualSlotIndex = index;
        bool isLunchBreak = false;

        if (lunchBreakIndex != null) {
          if (index == lunchBreakIndex) {
            isLunchBreak = true;
          } else if (index > lunchBreakIndex) {
            actualSlotIndex = index - 1;
          }
        }

        if (isLunchBreak) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: AppTheme.tokens.spacingMd),
            child: Row(
              children: [
                const Expanded(child: AppDivider()),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.tokens.spacingMd,
                  ),
                  child: Text(
                    "ÖĞLE ARASI",
                    style: context.moonTypography?.body.text10.copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const Expanded(child: AppDivider()),
              ],
            ),
          );
        }

        final slot = timings[actualSlotIndex];
        final lesson = dayLessons.cast<Lesson?>().firstWhere(
          (l) => l?.slotIndex == actualSlotIndex,
          orElse: () => null,
        );

        final timeRange =
            '${_formatMinutes(slot.start)} - ${_formatMinutes(slot.end)}';

        if (lesson == null) {
          return _buildEmptySlot(
            context,
            actualSlotIndex,
            timeRange,
            colors,
            selectedDay,
          );
        }

        final subject = subjects.firstWhere(
          (s) => s.id == lesson.subjectId,
          orElse: () =>
              Subject(id: '?', name: 'Bilinmeyen Ders', color: '#808080'),
        );

        final subjectColor = Color(
          int.parse(subject.color.replaceFirst('#', '0xFF')),
        );

        return _buildLessonCard(
          context,
          ref,
          lesson,
          subject,
          subjectColor,
          timeRange,
          colors,
        );
      },
    );
  }

  Widget _buildEmptySlot(
    BuildContext context,
    int index,
    String timeRange,
    AppColors colors,
    int selectedDay,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.tokens.spacingSm),
      child: AppCard(
        padding: EdgeInsets.all(AppTheme.tokens.spacingSm + 2),
        onTap: () => _showAddLessonModal(
          context,
          initialSlot: index,
          initialDay: selectedDay,
        ),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              // Col 1: Time (Keep strictly aligned with lessons)
              _buildGridColumn(
                context,
                flex: 2, // Reduced from 3
                child: _buildTimeText(context, index, timeRange, colors),
              ),
              // Col 2: Left-aligned "Empty" State (Merging remaining space)
              Expanded(
                flex:
                    10, // 2 + 10 = 12 (Total flex matches Lesson Card: 2+5+2+3=12)
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'DERS EKLENMEDİ',
                      style: context.moonTypography?.body.text10.copyWith(
                        color: colors.textSecondary.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Hidden action alignment spacer if needed, but flex 10 covers it all visually centered.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    WidgetRef ref,
    Lesson lesson,
    Subject subject,
    Color subjectColor,
    String timeRange,
    AppColors colors,
  ) {
    return Dismissible(
      key: Key(lesson.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(lessonsNotifierProvider.notifier).deleteLesson(lesson.id);
        AppModal.showToast(context: context, message: "Ders silindi.");
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppTheme.tokens.spacingSm),
        child: Container(
          padding: EdgeInsets.all(AppTheme.tokens.spacingSm + 2),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
            border: Border.all(
              color: subjectColor,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                // Col 1: Time
                _buildGridColumn(
                  context,
                  flex: 2, // Reduced from 3
                  child: _buildTimeText(
                    context,
                    lesson.slotIndex,
                    timeRange,
                    colors,
                    color: subjectColor,
                  ),
                ),
                // Col 2: Subject + AKTS (Moved Left)
                _buildGridColumn(
                  context,
                  flex: 7, // Increased from 5
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject.name,
                        style: context.moonTypography?.heading.text14.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (subject.ects != null)
                        Text(
                          '${subject.ects} AKTS',
                          style: context.moonTypography?.body.text10.copyWith(
                            color: colors.textSecondary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
                // Col 3: Classroom (Moved Right)
                _buildGridColumn(
                  context,
                  flex: 3, // Increased from 2
                  child: Text(
                    subject.classroom ?? '',
                    style: context.moonTypography?.body.text12.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                // Col 5: Delete
                AppIconButton(
                  icon: MoonIcons.controls_close_24_regular,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                  iconSize: 20,
                  padding: 4,
                  onTap: () {
                    ref
                        .read(lessonsNotifierProvider.notifier)
                        .deleteLesson(lesson.id);
                    AppModal.showToast(
                      context: context,
                      message: "Ders silindi.",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridColumn(
    BuildContext context, {
    required int flex,
    required Widget child,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(
    BuildContext context,
    int index,
    String timeRange,
    AppColors colors, {
    Color? color,
  }) {
    final style = context.moonTypography?.body.text10.copyWith(
      color: color ?? colors.textSecondary,
      fontWeight: FontWeight.w600,
      height: 1.1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${index + 1}. DERS',
          style: style?.copyWith(
            fontSize: 7,
            color:
                color?.withValues(alpha: 0.6) ??
                colors.textSecondary.withValues(alpha: 0.5),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(timeRange.replaceAll(' - ', '\n'), style: style),
      ],
    );
  }

  Widget _buildExamStatusAction(
    BuildContext context,
    WidgetRef ref,
    AppColors colors,
  ) {
    return AppButton(
      label: "Sınavları Görüntüle",
      onTap: () => context.push('/exams'),
      isFullWidth: false,
    );
  }

  String _formatMinutes(int minutes) {
    final h = (minutes / 60).floor();
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  Widget _buildExamsPreview(
    BuildContext context,
    AppColors colors,
    List<Exam> upcomingExams,
    DateTime now,
  ) {
    return Container(
      padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MoonIcons.files_file_24_regular,
                size: 16,
                color: colors.error,
              ),
              SizedBox(width: AppTheme.tokens.spacingXs + 2),
              Text(
                'Yaklaşan Sınavlar',
                style: context.moonTypography?.body.text12.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.tokens.spacingSm),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingExams.length,
              itemBuilder: (context, index) {
                final exam = upcomingExams[index];
                final daysUntil = exam.date.difference(now).inDays + 1;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: daysUntil <= 2
                        ? colors.error.withValues(alpha: 0.1)
                        : colors.brand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: daysUntil <= 2
                          ? colors.error.withValues(alpha: 0.3)
                          : colors.brand.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${exam.date.day}',
                        style: context.moonTypography?.heading.text20.copyWith(
                          color: daysUntil <= 2 ? colors.error : colors.brand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: AppTheme.tokens.spacingSm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exam.title,
                            style: context.moonTypography?.body.text12.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          if (exam.classroom != null)
                            Text(
                              exam.classroom!,
                              style: context.moonTypography?.body.text10
                                  .copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          Text(
                            daysUntil == 0
                                ? 'Bugün!'
                                : (daysUntil == 1 ? 'Yarın' : '$daysUntil gün'),
                            style: context.moonTypography?.body.text10.copyWith(
                              color: daysUntil <= 2
                                  ? colors.error
                                  : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLessonModal(
    BuildContext context, {
    int? initialSlot,
    int? initialDay,
  }) {
    AppModal.show(
      context: context,
      child: AddLessonModal(initialSlot: initialSlot, initialDay: initialDay),
    );
  }
}
