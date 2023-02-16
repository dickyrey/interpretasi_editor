import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/repositories/user_article_repository.dart';

class GetDraftedArticle {
  GetDraftedArticle(this.repository);

  final UserArticleRepository repository;

  Future<Either<Failure, List<Article>>> execute() {
    return repository.getMyDraftedArticle();
  }
}
