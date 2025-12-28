import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppRating extends StatelessWidget {
  final double value;
  final int max;
  final ValueChanged<double>? onChanged;

  const AppRating({
    super.key,
    required this.value,
    this.max = 5,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final isSelected = index < value;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onChanged != null ? () => onChanged!(index + 1.0) : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.tokens.ratingItemPadding),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                color: isSelected ? AppTheme.tokens.ratingActiveColor : AppTheme.tokens.ratingInactiveColor,
                size: AppTheme.tokens.ratingStarSize,
              ),
            ),
          ),
        );
      }),
    );
  }
}
