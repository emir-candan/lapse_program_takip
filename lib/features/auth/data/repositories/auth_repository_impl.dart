import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  UserEntity? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  @override
  Future<UserEntity?> get currentUser async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(_mapFirebaseUser(userCredential.user)!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Giriş yapılırken bir hata oluştu');
    } catch (e) {
      return Left('Beklenmeyen bir hata: $e');
    }
  }

  @override
  Future<Either<String, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (name != null) {
        await userCredential.user?.updateDisplayName(name);
        await userCredential.user?.reload();
        // Updated user needs to be fetched again to get displayName
        final updatedUser = _firebaseAuth.currentUser;
        return Right(_mapFirebaseUser(updatedUser)!);
      }

      return Right(_mapFirebaseUser(userCredential.user)!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Kayıt olurken bir hata oluştu');
    } catch (e) {
      return Left('Beklenmeyen bir hata: $e');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left('Çıkış yapılamadı: $e');
    }
  }

  @override
  Future<Either<String, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Sıfırlama e-postası gönderilemedi');
    } catch (e) {
      return Left('Beklenmeyen bir hata: $e');
    }
  }
}
