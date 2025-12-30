import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../../theme/app_theme.dart';

class AppPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing; // Top right action button
  final bool scrollable;
  final EdgeInsets? padding;

  const AppPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Get tokens from AppTheme extension on context context.moonTheme or directly AppTheme.tokens
    // For now, let's stick to using context.moonTheme if possible for dynamic theme support, 
    // but we can use AppTheme.tokens for static values if needed.
    
    // We will use a mixed approach: context for colors/text, static tokens for geometry if safe.
    // Better to use context.moonTheme everywhere if possible, but our `AppTheme` uses a static `tokens` accessor too.
    
    final content = Padding(
      padding: padding ?? EdgeInsets.all(AppTheme.tokens.spacingMd),
      child: child,
    );

    // Header/Title is handled by Global AppBar in MainLayout.
    // Trailing actions should be moved to AppBar actions if needed.

    if (scrollable) {
      return SingleChildScrollView(
        child: content,
      );
    }

    return content;
  }
}
