import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/auth_repository.dart';

class CheckAuth {

  CheckAuth(this.repository);
  
  final AuthRepository repository;

  Future<Either<Failure, bool>> execute() {
    return repository.checkAuth();
  }
}
