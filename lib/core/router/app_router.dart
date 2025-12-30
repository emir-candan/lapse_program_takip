import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Şimdilik importlar hata vermesin diye geçici ekranlar tanımlıyoruz
// İleride bunları gerçek dosyalarına yönlendireceğiz.
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/layout/presentation/main_layout.dart';
import '../../features/programs/presentation/programs_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/showcase/presentation/components_showcase_screen.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Listen to valid or null user (AsyncValue)
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/', // Start at home, let redirect handle login check
    redirect: (context, state) {
      // If loading or error, don't redirect yet (or handle accordingly)
      if (authState.isLoading || authState.hasError) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final path = state.uri.toString();
      final isLoggingIn = path == '/login';
      final isShowcase = path == '/showcase';

      if (!isLoggedIn && !isLoggingIn && !isShowcase) {
        // If not logged in AND not on public pages (login, showcase), go to login
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        // If logged in and trying to go to login, go to home
        return '/';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
             // Redirect root '/' to '/dashboard' if needed, or stick to '/'
            builder: (context, state) => const HomeScreen(), 
          ),
          GoRoute(
            path: '/programs',
            builder: (context, state) => const ProgramsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
       // Component Showcase (Keep outside shell or inside as preferred. Outside for now)
      GoRoute(
        path: '/showcase',
        builder: (context, state) => const ComponentsShowcaseScreen(),
      ),
      // Root redirect
      GoRoute(
         path: '/',
         redirect: (_, __) => '/dashboard',
      ),
    ],
  );
});