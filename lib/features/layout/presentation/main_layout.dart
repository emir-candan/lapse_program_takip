import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/components/layout/app_card.dart';
import '../../../core/components/components.dart';
import '../../auth/presentation/providers/auth_controller.dart';
import '../../home/presentation/widgets/add_exam_modal.dart';
import '../../home/presentation/widgets/add_lesson_modal.dart';
import '../../home/presentation/widgets/add_subject_modal.dart';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
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
            // floatingActionButton: const _SpeedDialFab(), // Removed
            body: child,
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: SafeArea(child: const _SpeedDialFab()),
          ),
        ],
      ),
    );
  }

  String _getTitleForRoute(BuildContext context) {
    if (context.mounted == false) return "";
    try {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/dashboard')) return "Ders Programım";
      if (location.startsWith('/exams')) return "Sınavlar";
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

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Logo Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.colors(
                          context,
                        ).brand.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flash_on_rounded,
                        size: 20,
                        color: AppTheme.colors(context).brand,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "LAPSE",
                      style: context.moonTypography?.heading.text16.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2, // Modern spacing
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // MENU SECTION
              const _SidebarSectionLabel("MENÜ"),
              // Navigation Items
              _SidebarItem(
                icon: Icons.calendar_month_rounded,
                label: "Ders Programım",
                isSelected: GoRouterState.of(
                  context,
                ).uri.path.startsWith('/dashboard'),
                onTap: () {
                  context.go('/dashboard');
                  if (Scaffold.of(context).hasDrawer &&
                      Scaffold.of(context).isDrawerOpen) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              _SidebarItem(
                icon: Icons.assignment_rounded,
                label: "Sınavlar",
                isSelected: GoRouterState.of(
                  context,
                ).uri.path.startsWith('/exams'),
                onTap: () {
                  context.go('/exams');
                  if (Scaffold.of(context).hasDrawer &&
                      Scaffold.of(context).isDrawerOpen) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              _SidebarItem(
                icon: Icons.settings_suggest_rounded,
                label: "Program Ayarları",
                isSelected: GoRouterState.of(
                  context,
                ).uri.path.startsWith('/schedule-settings'),
                onTap: () {
                  context.go('/schedule-settings');
                  if (Scaffold.of(context).hasDrawer &&
                      Scaffold.of(context).isDrawerOpen) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),

        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              const Spacer(),
              // User Profile Card
              Padding(
                padding: const EdgeInsets.all(12), // Reduced outer padding
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ), // Compact inner padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null) ...[
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.colors(context).brand,
                              radius: 16, // Smaller avatar
                              child: Text(
                                (user.name?.isNotEmpty == true)
                                    ? user.name![0].toUpperCase()
                                    : "U",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Smaller text
                                ),
                              ),
                            ),
                            const SizedBox(width: 8), // Tighter gap
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name ?? user.email,
                                    style: context.moonTypography?.body.text12
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ), // Smaller but bold
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    user.role,
                                    style: context
                                        .moonTypography
                                        ?.body
                                        .text10 // Even smaller for role
                                        .copyWith(
                                          color: AppTheme.colors(
                                            context,
                                          ).textSecondary,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Compact Icon Actions
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.settings_outlined,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(6),
                                  ),
                                  onPressed: () {
                                    context.go('/settings');
                                    if (Scaffold.of(context).hasDrawer &&
                                        Scaffold.of(context).isDrawerOpen) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  tooltip: "Ayarlar",
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(
                                    Icons.logout_rounded,
                                    size: 20,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(6),
                                  ),
                                  color: AppTheme.colors(context).error,
                                  onPressed: () {
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .signOut();
                                  },
                                  tooltip: "Çıkış Yap",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ] else ...[
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
              const SizedBox(height: 16), // Bottom safe area margin
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  final String label;
  const _SidebarSectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24, bottom: 8),
      child: Text(
        label,
        style: context.moonTypography?.body.text10.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: AppTheme.colors(context).textSecondary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    // Active state styles
    final activeBg = colors.brand;
    final activeFg = colors.onBrand;
    // Inactive state styles
    final inactiveIcon = colors.textSecondary;
    final inactiveText = colors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.brand.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3), // "Hafif kabartılı" effect
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.tokens.radiusMd),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? activeFg : inactiveIcon,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: context.moonTypography?.body.text14.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? activeFg : inactiveText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeedDialFab extends StatefulWidget {
  const _SpeedDialFab();

  @override
  State<_SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<_SpeedDialFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildStep(
          icon: Icons.school_rounded,
          label: "Ders Programa Ekle",
          color: Colors
              .indigo, // Changed from brand to info to avoid green overlap
          onTap: () {
            _toggle();
            AppModal.show(context: context, child: const AddLessonModal());
          },
          index: 2,
        ),
        _buildStep(
          icon: Icons.assignment_rounded,
          label: "Sınav Ekle",
          color: colors.error,
          onTap: () {
            _toggle();
            AppModal.show(context: context, child: const AddExamModal());
          },
          index: 1,
        ),
        _buildStep(
          icon: Icons.subject_rounded,
          label: "Yeni Ders Tanımla",
          color: colors.warning, // Distinct color for Subject definition
          onTap: () {
            _toggle();
            AppModal.show(context: context, child: const AddSubjectModal());
          },
          index: 0,
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'main_fab',
          onPressed: _toggle,
          backgroundColor: colors.brand,
          elevation: 4,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            turns: _isOpen ? 0.125 : 0, // 45 degrees
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required int index,
  }) {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: FadeTransition(
        opacity: _expandAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Label
              ScaleTransition(
                scale: _expandAnimation,
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors(context).surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors(context).textPrimary,
                    ),
                  ),
                ),
              ),
              // Button
              // Normal FAB: 56px, Small FAB: 40px. Diff: 16px -> 8px padding to center.
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FloatingActionButton.small(
                  heroTag: 'fab_$index',
                  onPressed: onTap,
                  backgroundColor: color,
                  elevation: 3,
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
