import 'package:flutter/material.dart';
import 'app_text_input.dart';

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
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: AbsorbPointer(
         child: AppTextInput(
           hintText: label, 
           prefixIcon: Icons.calendar_today,
           controller: TextEditingController(text: value?.toString().split(' ')[0]),
         ),
      ),
    );
  }
}
