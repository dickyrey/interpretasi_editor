import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/auth_repository.dart';

class SignInWithEmail {
  SignInWithEmail(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, void>> execute({
    required String email,
    required String password,
  }) {
    return repository.signInWithEmail(email: email, password: password);
  }
}
