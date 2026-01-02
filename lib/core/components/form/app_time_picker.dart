import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'app_text_input.dart';

class AppTimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final String label;
  final bool enabled;

  const AppTimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = "Saat Seçiniz",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = value != null
        ? "${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}"
        : "";

    final timePicker = GestureDetector(
      onTap: enabled
          ? () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: value ?? const TimeOfDay(hour: 9, minute: 0),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) onChanged(picked);
            }
          : null,
      child: AbsorbPointer(
        child: AppTextInput(
          hintText: label,
          prefixIcon: MoonIcons.time_time_24_regular,
          controller: TextEditingController(text: timeStr),
          // Assuming AppTextInput handles isEnabled or similar
          // If not, we'll just rely on Opacity and AbsorbPointer
        ),
      ),
    );

    if (!enabled) {
      return Opacity(opacity: 0.5, child: timePicker);
    }

    return timePicker;
  }
}
