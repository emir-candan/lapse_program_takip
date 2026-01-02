import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../calendar/presentation/providers/calendar_providers.dart';

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance);
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
    state = await AsyncValue.guard(
      () => _authRepository
          .signInWithEmail(email: email, password: password)
          .then(
            (result) =>
                result.fold((error) => throw Exception(error), (user) async {
                  // Sync data from backend on login
                  await _syncCalendarData();
                  return null;
                }),
          ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authRepository
          .signUpWithEmail(email: email, password: password, name: name)
          .then(
            (result) =>
                result.fold((error) => throw Exception(error), (user) async {
                  // Sync data from backend on signup
                  await _syncCalendarData();
                  return null;
                }),
          ),
    );
  }

  /// Sync calendar data from backend after login
  Future<void> _syncCalendarData() async {
    final repository = ref.read(calendarRepositoryProvider);
    await repository.forceRefresh();

    // Trigger notifier refresh to pick up new cache
    ref.read(lessonsNotifierProvider.notifier).refresh();
    ref.read(examsNotifierProvider.notifier).refresh();
    ref.read(subjectsNotifierProvider.notifier).refresh();
    ref.read(scheduleSettingsNotifierProvider.notifier).refresh();
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    // Clear local cache before logout
    final localDatasource = ref.read(calendarLocalDatasourceProvider);
    await localDatasource.clearAll();

    state = await AsyncValue.guard(
      () => _authRepository.signOut().then(
        (result) => result.fold((error) => throw Exception(error), (_) => null),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authRepository
          .resetPassword(email)
          .then(
            (result) =>
                result.fold((error) => throw Exception(error), (_) => null),
          ),
    );
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
