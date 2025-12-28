import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> get currentUser;
  
  Stream<UserEntity?> get authStateChanges;

  Future<Either<String, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<String, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  Future<Either<String, void>> signOut();
  
  Future<Either<String, void>> resetPassword(String email);
}
