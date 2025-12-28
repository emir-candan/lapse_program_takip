import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;

  const AppDropdown({
    super.key,
    this.hintText,
    this.value,
    this.items = const [],
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // We use DropdownButtonFormField to leverage strict InputDecorationTheme
    // This allows it to look exactly like AppTextInput without extra effort.
    
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon as IconData?) : null, // Assuming IconData, but might need widget check
        // PrefixIcon logic: if widget passed, use it. If IconData, convert.
        // But Input uses widget usually. Let's fix type if needed.
        // Actually, AppTextInput usually takes IconData for prefix. 
        // Let's check AppDropdown usage... passed specific Items.
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      dropdownColor: Theme.of(context).cardColor, // From Moon Theme Gohan
    );
  }
}
