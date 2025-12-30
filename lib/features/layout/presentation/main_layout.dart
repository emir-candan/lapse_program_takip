import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/components/layout/app_card.dart';
import '../../auth/presentation/providers/auth_controller.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  // Key to control the root scaffold (drawer)
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.colors(context).background,
      drawer: Drawer(
        backgroundColor: AppTheme.colors(context).sidebar,
        child: const _SidebarContent(),
      ),
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.colors(context).sidebar,
              boxShadow: AppTheme.tokens.layoutShadow,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Handled by container
              scrolledUnderElevation: 0,
              elevation: 0,
              centerTitle: true,
              title: Text(
                _getTitleForRoute(context),
                style: context.moonTypography?.heading.text16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Open the Root Scaffold's drawer
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  tooltip: "Bildirimler",
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        backgroundColor: AppTheme.colors(context).background, // Match theme
        body: child,
      ),
    );
  }

  String _getTitleForRoute(BuildContext context) {
    if (context.mounted == false) return "";
    // GoRouterState might not be directly available on context in some versions,
    // but usually GoRouterState.of(context) works.
    // If not, we rely on the URL string matching.
    try {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/dashboard')) return "Panel";
      if (location.startsWith('/programs')) return "Programlar";
      if (location.startsWith('/settings')) return "Ayarlar";
      if (location.startsWith('/components')) return "Bileşenler";
      return "";
    } catch (e) {
      return "";
    }
  }
}

class _SidebarContent extends ConsumerWidget {
  const _SidebarContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Column(
      children: [
        const SizedBox(height: 32),
        // Logo Area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              const Icon(Icons.flash_on, size: 28), // Placeholder Logo
              const SizedBox(width: 12),
              Text(
                "LAPSE",
                style: context.moonTypography?.heading.text16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Navigation Items
        _SidebarItem(
          icon: Icons.dashboard_rounded,
          label: "Panel",
          onTap: () {
            context.go('/dashboard');
            if (Scaffold.of(context).hasDrawer &&
                Scaffold.of(context).isDrawerOpen) {
              Navigator.of(context).pop();
            }
          },
        ),
        _SidebarItem(
          icon: Icons.calendar_month_rounded,
          label: "Programlar",
          onTap: () {
            context.go('/programs');
            if (Scaffold.of(context).hasDrawer &&
                Scaffold.of(context).isDrawerOpen) {
              Navigator.of(context).pop();
            }
          },
        ),

        const Spacer(),

        // User Profile Card
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.colors(context).brand,
                        radius: 20,
                        child: Text(
                          (user.name?.isNotEmpty == true)
                              ? user.name![0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? user.email,
                              style: context.moonTypography?.body.text14
                                  .copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.role,
                              style: context.moonTypography?.body.text12
                                  .copyWith(
                                    color: AppTheme.colors(
                                      context,
                                    ).textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Icon Actions
                      IconButton(
                        icon: Icon(Icons.settings_outlined, size: 20),
                        onPressed: () {
                          context.go('/settings');
                          if (Scaffold.of(context).hasDrawer &&
                              Scaffold.of(context).isDrawerOpen) {
                            Navigator.of(context).pop();
                          }
                        },
                        tooltip: "Ayarlar",
                        splashRadius: 20,
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_rounded, size: 20),
                        color: AppTheme.colors(context).error,
                        onPressed: () {
                          ref.read(authControllerProvider.notifier).signOut();
                        },
                        tooltip: "Çıkış Yap",
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ] else ...[
                  // Fallback if no user
                  Text(
                    "Kullanıcı bilgisi yok",
                    style: context.moonTypography?.body.text12.copyWith(
                      color: AppTheme.colors(context).textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.colors(context).textPrimary),
      title: Text(label, style: context.moonTypography?.body.text14),
      onTap: onTap,
    );
  }
}
