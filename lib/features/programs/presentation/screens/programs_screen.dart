import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../../core/components/components.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';
import '../widgets/add_program_modal.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final programsAsync = ref.watch(programsStreamProvider);

    return AppPageLayout(
      title: "Programlar",
      scrollable: true,
      child: Column(
        children: [
          // Explicit Header for Actions since Global AppBar doesn't support page-specific actions yet
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Program Listesi",
                style: context.moonTypography?.heading.text20.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              AppIconButton(
                icon: MoonIcons.controls_plus_24_regular,
                onTap: () {
                  AppModal.show(
                    context: context,
                    child: const AddProgramModal(),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: AppTheme.tokens.spacingMd),
          programsAsync.when(
            data: (programs) {
              if (programs.isEmpty) {
                return const AppEmptyState(
                  message: "Henüz bir program eklenmemiş.",
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: programs.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppTheme.tokens.spacingSm),
                itemBuilder: (context, index) {
                  final program = programs[index];
                  final color = Color(int.parse(program.color));

                  return AppCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundColor: color, radius: 12),
                      title: Text(
                        program.title,
                        style: context.moonTypography?.body.text16.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle:
                          program.description != null &&
                              program.description!.isNotEmpty
                          ? Text(
                              program.description!,
                              style: context.moonTypography?.body.text14
                                  .copyWith(color: colors.textSecondary),
                            )
                          : null,
                      trailing: AppIconButton(
                        icon: MoonIcons.generic_delete_24_regular,
                        backgroundColor: Colors.transparent,
                        color: colors.error,
                        onTap: () {
                          // Confirm delete
                          // Ideally show a confirmation dialog, but for now strict implementation
                          ref
                              .read(calendarRepositoryProvider)
                              .deleteProgram(program.id);
                          AppModal.showToast(
                            context: context,
                            message: "Program silindi.",
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            error: (err, stack) => Center(child: Text('Hata: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
