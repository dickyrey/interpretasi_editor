import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/article_repository.dart';

class UpdateArticle {
  UpdateArticle(this.repository);
  final ArticleRepository repository;

  Future<Either<Failure, void>> execute({
    required int categoryId,
    required XFile? image,
    required String id,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  }) {
    return repository.updateArticle(
      categoryId: categoryId,
      image: image,
      id: id,
      title: title,
      content: content,
      deltaJson: deltaJson,
      tags: tags,
    );
  }
}
