import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}
