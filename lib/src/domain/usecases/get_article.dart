import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/repositories/article_repository.dart';

class GetArticle {
  GetArticle(this.repository);

  final ArticleRepository repository;

  Future<Either<Failure, List<Article>>> execute({
    required String page,
    required String query,
    required String category,
    required bool isTrending,
  }) {
    return repository.getArticle(
      page: page,
      query: query,
      category: category,
      isTrending: isTrending,
    );
  }
}
