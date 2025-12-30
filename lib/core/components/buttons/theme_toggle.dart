import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Faster
        curve: Curves.easeOut, // No bounce, direct
        width: 70,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFF60A5FA),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Stars (Visible only in Dark Mode)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              top: 8,
              left: isDark ? 10 : -30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isDark ? 1.0 : 0.0,
                child: const Icon(Icons.star, color: Colors.white, size: 10),
              ),
            ),
             AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              bottom: 8,
              left: isDark ? 20 : -30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isDark ? 1.0 : 0.0,
                child: const Icon(Icons.star, color: Colors.white, size: 6),
              ),
            ),

            // Clouds (Visible only in Light Mode)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              top: 8,
              right: isDark ? -30 : 10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isDark ? 0.0 : 1.0,
                child: const Icon(Icons.cloud, color: Colors.white, size: 12),
              ),
            ),
             AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              bottom: 6,
              right: isDark ? -30 : 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isDark ? 0.0 : 1.0,
                child: const Icon(Icons.cloud, color: Colors.white, size: 8),
              ),
            ),

            // The Knob (Sun / Moon)
            AnimatedAlign(
              duration: const Duration(milliseconds: 200), // Much fast transition
              curve: Curves.easeOut, // Direct movement, no bounce/elastic
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFFFDB813),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      size: 18,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
