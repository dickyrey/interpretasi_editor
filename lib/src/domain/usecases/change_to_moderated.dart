import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/user_article_repository.dart';

class ChangeToModerated {
  ChangeToModerated(this.repository);

  final UserArticleRepository repository;

  Future<Either<Failure, bool>> execute(String id) {
    return repository.changeToModerated(id);
  }
}
