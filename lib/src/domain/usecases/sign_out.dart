import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/auth_repository.dart';

class SignOut {
  SignOut(this.repository);
  
  final AuthRepository repository;

  Future<Either<Failure, void>> execute() {
    return repository.signOut();
  }
}
