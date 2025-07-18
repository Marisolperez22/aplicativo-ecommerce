import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/errors/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Cart>>> getUserCart(int idUser);
  Future<Either<Failure, Product>> getProductDetail(int productId);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
