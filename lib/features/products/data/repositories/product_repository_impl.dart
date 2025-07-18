import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/products_datasource.dart';
import '../../domain/repositories/product_repository.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final IProductsDatasource _productsDatasources;

  ProductRepositoryImpl({required IProductsDatasource productsDatasources})
    : _productsDatasources = productsDatasources;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await _productsDatasources.getProducts();
      return Right(products);
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(int productId) async {
    try {
      final product = await _productsDatasources.getProductDetail(productId);
      return Right(product);
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _productsDatasources.getCategories();
      return Right(categories);
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final productsByCategory = await _productsDatasources
          .getProductsByCategory(category);
      return Right(productsByCategory);
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<Cart>>> getUserCart(int idUser) async {
    try {
      final cart = await _productsDatasources.getUserCart(idUser);
      return Right(cart);
    } catch (e) {
      return Utils.handleException(e);
    }
  }
}
