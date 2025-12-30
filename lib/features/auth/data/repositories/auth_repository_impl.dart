import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firebaseFirestore);

  Future<UserEntity?> _getUserFromFirestore(User firebaseUser) async {
    try {
      print('[AuthRepository] Fetching user doc for ${firebaseUser.uid}...');
      final doc = await _firebaseFirestore.collection('users').doc(firebaseUser.uid).get();
      print('[AuthRepository] Doc exists: ${doc.exists}');
      
      if (doc.exists) {
        final data = doc.data();
        return UserEntity(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: data?['name'] ?? firebaseUser.displayName,
          role: data?['role'] ?? 'user',
        );
      }
      
      print('[AuthRepository] Doc does not exist, using fallback.');
      // Fallback if no firestore doc exists
      return UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        role: 'user',
      );
    } catch (e) {
      print('[AuthRepository] Error fetching user doc: $e');
      // Return a basic entity instead of null so we don't crash
      return UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        role: 'user',
      );
    }
  }

  @override
  Future<UserEntity?> get currentUser async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _getUserFromFirestore(user);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _getUserFromFirestore(user);
    });
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('[AuthRepository] Signing in...');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('[AuthRepository] Auth successful. Fetching profile...');
      final userEntity = await _getUserFromFirestore(userCredential.user!);
      
      if (userEntity == null) {
         return Left('Kullanıcı profili alınamadı.');
      }
      
      return Right(userEntity);
    } on FirebaseAuthException catch (e) {
      print('[AuthRepository] FirebaseAuthException: $e');
      return Left(e.message ?? 'Giriş yapılırken bir hata oluştu');
    } catch (e) {
      print('[AuthRepository] Exception: $e');
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
      print('[AuthRepository] Signing up...');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      print('[AuthRepository] User created: ${user.uid}');
      
      // Update Display Name in Auth
      if (name != null) {
        await user.updateDisplayName(name);
      }

      // Create User Document in Firestore
      print('[AuthRepository] Creating Firestore document...');
      await _firebaseFirestore.collection('users').doc(user.uid).set({
        'email': email,
        'name': name ?? '',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('[AuthRepository] Firestore document created.');

      return Right(UserEntity(
        id: user.uid,
        email: email,
        name: name,
        role: 'user',
      ));
    } on FirebaseAuthException catch (e) {
      print('[AuthRepository] SignUp FirebaseAuthException: $e');
      return Left(e.message ?? 'Kayıt olurken bir hata oluştu');
    } catch (e) {
      print('[AuthRepository] SignUp Exception: $e');
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
