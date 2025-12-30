import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if we are on a desktop-sized screen for Sidebar vs BottomNav
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    // Simulating current index based on location string would be ideal, 
    // but simplified for now we rely on user clicking.
    // In a real app we'd map location to index.

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _DesktopSidebar(),
            
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isDesktop 
          ? null 
          : _MobileBottomNav(),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using a simple Container for now, will enhance with Moon Design components
    return Container(
      width: 250,
      color: context.moonColors?.goku,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                const Icon(Icons.flash_on, size: 28), // Placeholder Logo
                const SizedBox(width: 12),
                Text("LAPSE", style: context.moonTypography?.heading.text16.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          
          // Navigation Items
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: "Panel",
            onTap: () => context.go('/dashboard'),
          ),
          _SidebarItem(
            icon: Icons.calendar_month_rounded, 
            label: "Programlar",
             onTap: () => context.go('/programs'),
          ),
           _SidebarItem(
            icon: Icons.settings_rounded,
            label: "Ayarlar",
             onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.moonColors?.textPrimary),
      title: Text(label, style: context.moonTypography?.body.text14),
      onTap: onTap,
    );
  }
}

class _MobileBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        if (index == 0) context.go('/dashboard');
        if (index == 1) context.go('/programs');
        if (index == 2) context.go('/settings');
      },
      selectedIndex: 0, // TODO: Sync with Router state
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Panel',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month_rounded),
          label: 'Programlar',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label: 'Ayarlar',
        ),
      ],
    );
  }
}
