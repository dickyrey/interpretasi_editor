import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/entities/article_detail.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticle({
    required String page,
    required String query,
    required String category,
    required bool isTrending,
  });
  Future<Either<Failure, ArticleDetail>> getArticleDetail(String id);
  Future<Either<Failure, bool>> deleteArticle(String id);
  Future<Either<Failure, bool>> createArticle({
    required int categoryId,
    required XFile image,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  });
  Future<Either<Failure, bool>> updateArticle({
    required int categoryId,
    required XFile? image,
    required String id,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  });
  Future<Either<Failure, String>> uploadImage(XFile image);
}
