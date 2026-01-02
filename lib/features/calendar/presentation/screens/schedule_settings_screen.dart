import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_design/moon_design.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/components/components.dart';
import '../../../calendar/domain/entities/schedule_settings.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';

class ScheduleSettingsScreen extends ConsumerStatefulWidget {
  const ScheduleSettingsScreen({super.key});

  @override
  ConsumerState<ScheduleSettingsScreen> createState() =>
      _ScheduleSettingsScreenState();
}

class _ScheduleSettingsScreenState
    extends ConsumerState<ScheduleSettingsScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _classDuration = 40;
  int _breakDuration = 10;

  bool _hasLunchBreak = true;
  TimeOfDay? _lunchStartTime;
  TimeOfDay? _lunchEndTime;

  bool _isLoading = false;

  final List<int> _durationOptions = [15, 20, 30, 40, 45, 50, 60, 90];
  final List<int> _breakOptions = [5, 10, 15, 20, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(scheduleSettingsNotifierProvider).valueOrNull;
      if (settings != null) {
        setState(() {
          _startTime = TimeOfDay(
            hour: settings.startHour,
            minute: settings.startMinute,
          );
          _endTime = TimeOfDay(
            hour: settings.endHour,
            minute: settings.endMinute,
          );
          _classDuration = settings.classDuration;
          _breakDuration = settings.breakDuration;

          _hasLunchBreak = settings.lunchBreakStartHour != null;
          if (_hasLunchBreak) {
            _lunchStartTime = TimeOfDay(
              hour: settings.lunchBreakStartHour!,
              minute: settings.lunchBreakStartMinute ?? 0,
            );
            _lunchEndTime = TimeOfDay(
              hour: settings.lunchBreakEndHour!,
              minute: settings.lunchBreakEndMinute ?? 0,
            );
          }
        });
      }
    });
  }

  Future<void> _save() async {
    if (_startTime == null || _endTime == null) {
      AppModal.showToast(
        context: context,
        message: "Lütfen okul saatlerini seçin.",
      );
      return;
    }

    setState(() => _isLoading = true);

    final settings = ScheduleSettings(
      startHour: _startTime!.hour,
      startMinute: _startTime!.minute,
      endHour: _endTime!.hour,
      endMinute: _endTime!.minute,
      classDuration: _classDuration,
      breakDuration: _breakDuration,
      lunchBreakStartHour: _hasLunchBreak ? _lunchStartTime?.hour : null,
      lunchBreakStartMinute: _hasLunchBreak ? _lunchStartTime?.minute : null,
      lunchBreakEndHour: _hasLunchBreak ? _lunchEndTime?.hour : null,
      lunchBreakEndMinute: _hasLunchBreak ? _lunchEndTime?.minute : null,
    );

    await ref
        .read(scheduleSettingsNotifierProvider.notifier)
        .updateSettings(settings);

    if (mounted) {
      setState(() => _isLoading = false);
      AppModal.showToast(context: context, message: "Ayarlar kaydedildi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: "Okul Ayarları",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foundational Hero Section
          Container(
            padding: EdgeInsets.all(AppTheme.tokens.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.colors(context).brand.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
              border: Border.all(
                color: AppTheme.colors(context).brand.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      MoonIcons.other_frame_24_regular,
                      color: AppTheme.colors(context).brand,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Programınızın Temeli",
                      style: context.moonTypography?.heading.text18.copyWith(
                        color: AppTheme.colors(context).brand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Buradaki ayarlar, ders programınızın iskeletini oluşturur. Okul saatlerinizi ve ders sürelerinizi bir kez doğru girerek tüm ders programınızı tek seferde planlayabilirsiniz.",
                  style: context.moonTypography?.body.text12.copyWith(
                    color: AppTheme.colors(context).textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 1. Okul Giriş-Çıkış
          _buildSectionHeader(
            title: "Okul Giriş ve Çıkış Saatleri",
            description:
                "Okulunuzun ilk dersinin başlangıç ve son dersinin bitiş saatini belirleyin.",
          ),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: AppTimePicker(
                    label: "Okul Başlangıcı",
                    value: _startTime,
                    onChanged: (v) => setState(() => _startTime = v),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("-"),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTimePicker(
                    label: "Okul Bitişi",
                    value: _endTime,
                    onChanged: (v) => setState(() => _endTime = v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Ders ve Ders Arası Uzunluğu
          _buildSectionHeader(
            title: "Ders ve Ders Arası Uzunluğu",
            description:
                "Okulunuzun standart ders ve ders arası sürelerini seçin.",
          ),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _buildDurationDropdown(
                    label: "Ders (Dakika)",
                    value: _classDuration,
                    options: _durationOptions,
                    onChanged: (v) => setState(() => _classDuration = v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDurationDropdown(
                    label: "Ders Arası (Dakika)",
                    value: _breakDuration,
                    options: _breakOptions,
                    onChanged: (v) => setState(() => _breakDuration = v!),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Öğle Arası
          _buildSectionHeader(
            title: "Öğle Arası",
            description:
                "Öğle arası saati tanımlayarak derslerin bu saatlerde çakışmamasını sağlayın.",
          ),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: AppTimePicker(
                    label: "Başlangıç",
                    enabled: _hasLunchBreak,
                    value: _lunchStartTime,
                    onChanged: (v) => setState(() => _lunchStartTime = v),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("-"),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTimePicker(
                    label: "Bitiş",
                    enabled: _hasLunchBreak,
                    value: _lunchEndTime,
                    onChanged: (v) => setState(() => _lunchEndTime = v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: AppCheckbox(
              label: "Öğle aram var",
              value: _hasLunchBreak,
              onChanged: (v) => setState(() => _hasLunchBreak = v ?? false),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: "Ayarları Kaydet",
              isLoading: _isLoading,
              onTap: _save,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.moonTypography?.heading.text16.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.moonTypography?.body.text12.copyWith(
              color: AppTheme.colors(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationDropdown({
    required String label,
    required int value,
    required List<int> options,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.moonTypography?.body.text12.copyWith(
            color: AppTheme.colors(context).textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        AppDropdown<int>(
          value: value,
          onChanged: onChanged,
          items: options.map((opt) {
            return DropdownMenuItem<int>(value: opt, child: Text("$opt dk"));
          }).toList(),
          hintText: "Seçin",
        ),
      ],
    );
  }
}
