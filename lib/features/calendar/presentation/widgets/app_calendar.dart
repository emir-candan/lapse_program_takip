import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/event.dart';
import '../providers/calendar_providers.dart';

class AppCalendar extends ConsumerWidget {
  const AppCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final eventsAsync = ref.watch(eventsStreamProvider);

    return AppCard(
      child: TableCalendar<Event>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selected, focused) {
          ref.read(selectedDateProvider.notifier).state = selected;
          ref.read(focusedDayProvider.notifier).state = focused;
        },
        onPageChanged: (focused) {
          ref.read(focusedDayProvider.notifier).state = focused;
        },
        eventLoader: (day) {
          return eventsAsync.when(
            data: (events) {
              return events.where((event) {
                if (event.isRecurring) {
                  return event.startDate.day == day.day &&
                      event.startDate.month == day.month;
                }
                return isSameDay(event.startDate, day);
              }).toList();
            },
            error: (_, __) => [],
            loading: () => [],
          );
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,

          // Typography
          // Typography
          defaultTextStyle:
              context.moonTypography?.body.text14.copyWith(
                color: colors.textPrimary,
              ) ??
              const TextStyle(),
          weekendTextStyle:
              context.moonTypography?.body.text14.copyWith(
                color: colors.textSecondary,
              ) ??
              const TextStyle(),
          todayTextStyle:
              context.moonTypography?.body.text14.copyWith(
                color: colors.brand,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(),
          selectedTextStyle:
              context.moonTypography?.body.text14.copyWith(
                color: colors.onBrand,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(),

          // Decorations
          todayDecoration: BoxDecoration(
            color: colors.brand.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: colors.brand,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.brand.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          // Marker Style
          markerSize: 6,
          markerDecoration: BoxDecoration(
            color: colors.brand,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle:
              context.moonTypography?.heading.text18.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(),
          leftChevronIcon: Icon(
            MoonIcons.controls_chevron_left_24_regular,
            color: colors.textPrimary,
          ),
          rightChevronIcon: Icon(
            MoonIcons.controls_chevron_right_24_regular,
            color: colors.textPrimary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              context.moonTypography?.body.text12.copyWith(
                color: colors.textSecondary,
              ) ??
              const TextStyle(),
          weekendStyle:
              context.moonTypography?.body.text12.copyWith(
                color: colors.textSecondary,
              ) ??
              const TextStyle(),
        ),
      ),
    );
  }
}
