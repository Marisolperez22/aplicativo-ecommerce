import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUsecase {
  final ProductRepository repository;

  GetProductsByCategoryUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(String category) async {
    if (category == 'Todas') {
      return await repository.getProducts();
    }
    return await repository.getProductsByCategory(category);
  }
}
