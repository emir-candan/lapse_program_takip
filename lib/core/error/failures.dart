import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Sunucu hatası oluştu']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Önbellek hatası oluştu']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Kimlik doğrulama hatası']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
