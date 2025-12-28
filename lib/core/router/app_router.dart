import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Şimdilik importlar hata vermesin diye geçici ekranlar tanımlıyoruz
// İleride bunları gerçek dosyalarına yönlendireceğiz.
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
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
      GoRoute(
        path: '/showcase',
        builder: (context, state) => const ComponentsShowcaseScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});