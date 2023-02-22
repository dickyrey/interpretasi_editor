import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/repositories/article_repository.dart';

class UploadImage {
  UploadImage(this.repository);
  final ArticleRepository repository;

  Future<Either<Failure, String>> execute(XFile image) {
    return repository.uploadImage(image);
  }
}
