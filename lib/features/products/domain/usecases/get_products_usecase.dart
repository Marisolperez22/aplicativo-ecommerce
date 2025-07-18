import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
