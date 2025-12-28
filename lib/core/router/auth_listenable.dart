import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulating a user state
class AuthState {
  final bool isAuthenticated;
  const AuthState({this.isAuthenticated = false});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(isAuthenticated: false); // Default: not logged in
  }

  void login() {
    state = const AuthState(isAuthenticated: true);
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
