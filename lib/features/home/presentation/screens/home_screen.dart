import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../../../calendar/presentation/widgets/app_calendar.dart';
import '../../../calendar/presentation/widgets/add_event_modal.dart';
// import '../../../programs/presentation/screens/programs_screen.dart'; // Removed unused import

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final eventsAsync = ref.watch(eventsStreamProvider);
    final programsAsync = ref.watch(programsStreamProvider);

    return AppPageLayout(
      title: "Takvimim",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Calendar
          const AppCalendar(),

          const SizedBox(height: 24),

          // 2. Events Header & Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Etkinlikler",
                style: context.moonTypography?.heading.text20.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              AppIconButton(
                icon: MoonIcons.controls_plus_24_regular,
                onTap: () {
                  AppModal.show(
                    context: context,
                    child: AddEventModal(initialDate: selectedDate),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3. Events List
          eventsAsync.when(
            data: (events) {
              // Client-side filtering for selected date
              // (Provider fetches for whole month)
              final dayEvents = events.where((event) {
                if (event.isRecurring) {
                  return event.startDate.day == selectedDate.day &&
                      event.startDate.month == selectedDate.month;
                }
                return isSameDay(event.startDate, selectedDate);
              }).toList();

              if (dayEvents.isEmpty) {
                return const AppEmptyState(message: "Bugün için etkinlik yok.");
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dayEvents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final event = dayEvents[index];

                  // Resolve Program Color
                  Color programColor = colors.textSecondary; // Default
                  String programName = "";

                  final programs = programsAsync.valueOrNull ?? [];
                  if (event.programId != null && programs.isNotEmpty) {
                    try {
                      final p = programs.firstWhere(
                        (p) => p.id == event.programId,
                      );
                      programColor = Color(int.parse(p.color));
                      programName = p.title;
                    } catch (_) {}
                  }

                  return AppCard(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: programColor, width: 4),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          AppModal.show(
                            context: context,
                            child: AddEventModal(
                              initialDate: selectedDate,
                              eventToEdit: event,
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          event.title,
                          style: context.moonTypography?.body.text16.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (programName.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  programName,
                                  style: context.moonTypography?.body.text12
                                      .copyWith(
                                        color: programColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            if (event.description != null &&
                                event.description!.isNotEmpty)
                              Text(
                                event.description!,
                                style: context.moonTypography?.body.text14
                                    .copyWith(color: colors.textSecondary),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Recurring Icon
                            if (event.isRecurring)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.repeat,
                                  size: 16,
                                  color: colors.textSecondary,
                                ),
                              ),

                            // Delete Action
                            AppIconButton(
                              icon: MoonIcons.generic_delete_24_regular,
                              backgroundColor: Colors.transparent,
                              color: colors.error, // Corrected parameter name
                              onTap: () {
                                ref
                                    .read(calendarRepositoryProvider)
                                    .deleteEvent(event.id);
                                AppModal.showToast(
                                  context: context,
                                  message: "Etkinlik silindi.",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text("Hata: $err"),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
