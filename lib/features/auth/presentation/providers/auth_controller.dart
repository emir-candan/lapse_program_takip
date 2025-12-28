import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance);
});

// Auth State Provider
final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Controller
class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.read(authRepositoryProvider);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signInWithEmail(
      email: email,
      password: password,
    ).then((result) => result.fold(
      (error) => throw Exception(error),
      (user) => null,
    )));
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    ).then((result) => result.fold(
      (error) => throw Exception(error),
      (user) => null,
    )));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut().then((result) => result.fold(
      (error) => throw Exception(error),
      (_) => null,
    )));
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.resetPassword(email).then((result) => result.fold(
      (error) => throw Exception(error),
      (_) => null,
    )));
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(AuthController.new);
