import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Şimdilik importlar hata vermesin diye geçici ekranlar tanımlıyoruz
// İleride bunları gerçek dosyalarına yönlendireceğiz.
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';

import 'auth_listenable.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Listen to auth state to trigger redirects
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/', // Start at home, let redirect handle login check
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        // If not logged in and not on login page, go to login
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
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});