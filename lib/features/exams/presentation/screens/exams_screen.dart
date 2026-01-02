import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../../calendar/domain/entities/exam.dart';
import '../../../calendar/domain/entities/subject.dart';

class ExamsScreen extends ConsumerWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final examsAsync = ref.watch(examsNotifierProvider);
    final subjectsAsync = ref.watch(subjectsNotifierProvider);

    final exams = examsAsync.valueOrNull ?? [];
    final subjects = subjectsAsync.valueOrNull ?? [];

    // Sort by date
    final sortedExams = List<Exam>.from(exams)
      ..sort((a, b) => a.date.compareTo(b.date));

    final now = DateTime.now();
    final upcomingExams = sortedExams
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 1))))
        .toList();
    final pastExams = sortedExams
        .where((e) => e.date.isBefore(now.subtract(const Duration(days: 1))))
        .toList();

    return AppPageLayout(
      title: "Sınavlar",
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats header
          Container(
            padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    colors,
                    '${upcomingExams.length}',
                    'Yaklaşan',
                    colors.brand,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    colors,
                    '${pastExams.length}',
                    'Geçmiş',
                    colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.tokens.spacingLg),

          // Upcoming exams
          if (upcomingExams.isNotEmpty) ...[
            Text(
              'Yaklaşan Sınavlar',
              style: context.moonTypography?.heading.text16.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppTheme.tokens.spacingSm),
            ...upcomingExams.map(
              (exam) => _buildExamCard(
                context,
                ref,
                colors,
                exam,
                subjects,
                isUpcoming: true,
              ),
            ),
            SizedBox(height: AppTheme.tokens.spacingLg),
          ],

          // Past exams
          if (pastExams.isNotEmpty) ...[
            Text(
              'Geçmiş Sınavlar',
              style: context.moonTypography?.heading.text16.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppTheme.tokens.spacingSm),
            ...pastExams.map(
              (exam) => _buildExamCard(
                context,
                ref,
                colors,
                exam,
                subjects,
                isUpcoming: false,
              ),
            ),
          ],
          // ... (rest of build remains same but uses subjects)

          // Empty state
          if (exams.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.tokens.spacingXl),
                child: Column(
                  children: [
                    Icon(
                      MoonIcons.files_file_24_regular,
                      size: 64,
                      color: colors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz sınav eklenmemiş',
                      style: context.moonTypography?.body.text16.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sağ alttaki + butonuna tıklayarak sınav ekleyebilirsiniz.',
                      style: context.moonTypography?.body.text14.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    AppColors colors,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: context.moonTypography?.heading.text24.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.moonTypography?.body.text12.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildExamCard(
    BuildContext context,
    WidgetRef ref,
    AppColors colors,
    Exam exam,
    List<Subject> subjects, {
    required bool isUpcoming,
  }) {
    final now = DateTime.now();
    final daysUntil = exam.date.difference(now).inDays;

    String? subjectName;
    if (exam.subjectId != null) {
      try {
        subjectName = subjects.firstWhere((s) => s.id == exam.subjectId).name;
      } catch (_) {}
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.tokens.spacingSm),
      padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.tokens.radiusSm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          // Date badge
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isUpcoming && daysUntil <= 3
                  ? colors.error.withValues(alpha: 0.1)
                  : colors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '${exam.date.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUpcoming && daysUntil <= 3
                        ? colors.error
                        : colors.brand,
                  ),
                ),
                Text(
                  _getMonthAbbr(exam.date.month),
                  style: TextStyle(
                    fontSize: 10,
                    color: isUpcoming && daysUntil <= 3
                        ? colors.error
                        : colors.brand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Exam info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: context.moonTypography?.body.text14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUpcoming
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
                if (subjectName != null)
                  Text(
                    subjectName,
                    style: context.moonTypography?.body.text12.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                if (exam.timeString != null)
                  Text(
                    'Saat: ${exam.timeString}',
                    style: context.moonTypography?.body.text12.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Delete button
          if (isUpcoming)
            AppIconButton(
              icon: MoonIcons.generic_delete_24_regular,
              backgroundColor: Colors.transparent,
              color: colors.error,
              onTap: () {
                ref.read(examsNotifierProvider.notifier).deleteExam(exam.id);
                AppModal.showToast(context: context, message: "Sınav silindi.");
              },
            ),
        ],
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return months[month - 1];
  }
}
