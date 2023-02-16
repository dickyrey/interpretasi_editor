import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/exception.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/data/datasources/auth_data_source.dart';
import 'package:interpretasi_editor/src/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(this.dataSource);

  final AuthDataSource dataSource;

  @override
  Future<Either<Failure, bool>> checkAuth() async {
    try {
      final result = await dataSource.checkAuth();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final result = await dataSource.signOut();
      return Right(result);
    } catch (e) {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }
}
