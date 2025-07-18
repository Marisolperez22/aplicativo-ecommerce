import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';


class GetProductDetailUseCase {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<Either<Failure, Product>> call(int productId) async {
    return await repository.getProductDetail(productId);
  }
}
