import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkAuth();
  Future<Either<Failure, bool>> signInWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
}
