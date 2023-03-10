import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/exception.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/data/datasources/article_data_source.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/entities/article_detail.dart';
import 'package:interpretasi_editor/src/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl extends ArticleRepository {
  ArticleRepositoryImpl(this.dataSource);

  final ArticleDataSource dataSource;

  @override
  Future<Either<Failure, List<Article>>> getArticle({
    required String page,
    required String query,
    required String category,
    required bool isTrending,
  }) async {
    try {
      final result = await dataSource.getArticle(
        page: page,
        query: query,
        category: category,
        isTrending: isTrending,
      );
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }

  @override
  Future<Either<Failure, ArticleDetail>> getArticleDetail(String id) async {
    try {
      final result = await dataSource.getArticleDetail(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> createArticle({
    required int categoryId,
    required XFile image,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  }) async {
    try {
      final result = await dataSource.createArticle(
        categoryId: categoryId,
        image: image,
        title: title,
        content: content,
        deltaJson: deltaJson,
        tags: tags,
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
  Future<Either<Failure, bool>> updateArticle({
    required int categoryId,
    required XFile? image,
    required String id,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  }) async {
    try {
      final result = await dataSource.updateArticle(
        categoryId: categoryId,
        image: image,
        id: id,
        title: title,
        content: content,
        deltaJson: deltaJson,
        tags: tags,
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
  Future<Either<Failure, bool>> deleteArticle(String id) async {
    try {
      final result = await dataSource.deleteArticle(id);
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
  Future<Either<Failure, String>> uploadImage(XFile image) async {
    try {
      final result = await dataSource.uploadImage(image);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure(ExceptionMessage.internetNotConnected),
      );
    }
  }
}
