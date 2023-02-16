import 'package:dartz/dartz.dart';
import 'package:interpretasi_editor/src/common/failure.dart';
import 'package:interpretasi_editor/src/domain/entities/category.dart';
import 'package:interpretasi_editor/src/domain/repositories/category_repository.dart';

class GetCategories {

  GetCategories(this.repository);
  
  final CategoryRepository repository;

  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}
