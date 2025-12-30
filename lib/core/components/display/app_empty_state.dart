import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const AppEmptyState({
    super.key,
    this.message = "Veri bulunamadı.",
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppTheme.tokens.emptyStateIconSize, color: AppTheme.colors(context).textSecondary),
          SizedBox(height: AppTheme.tokens.emptyStateSpacing),
          Text(
            message, 
            style: context.moonTypography?.body.text16.copyWith(
              color: AppTheme.colors(context).textSecondary
            ),
          ),
        ],
      ),
    );
  }
}
