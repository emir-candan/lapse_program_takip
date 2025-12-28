import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AppDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String label;

  const AppDatePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = "Tarih Seçiniz",
  });

  @override
  Widget build(BuildContext context) {
    // moon_ui_date_picker.dart
    // Usually a widget you inline or show in modal. Wrapper might just be the clickable field calling the specific picker.
    // Or MoonDatePicker might be the calendar widget itself.
    // Let's assume MoonDatePicker is the inline calendar or valid field.
    // If it's just the calendar, we need to wrap it in a Dialog/Popover.
    
    // For now, let's assume it's a widget we can use. If it's just a calendar, 
    // we might want to keep the logic of opening it but using MoonDatePicker content.
    
    // Actually, sticking to "Moon based", using MoonDatePicker directly is safest.
    return MoonDatePicker(
      initialDate: value ?? DateTime.now(),
      onDateSelected: onChanged,
      // other props
    );
  }
}
