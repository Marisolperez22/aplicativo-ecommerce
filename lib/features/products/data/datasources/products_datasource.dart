import 'package:fake_store_get_request/models/cart.dart';
import 'package:injectable/injectable.dart';

import 'package:fake_store_get_request/fake_store_get_request.dart';

abstract class IProductsDatasource {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<List<Cart>> getUserCart(int idUser);
  Future<Product> getProductDetail(int productId);
  Future<List<Product>> getProductsByCategory(String category);
}

@Injectable(as: IProductsDatasource)
class ProductsDatasource implements IProductsDatasource {
  final remoteDataSource = FakeStoreService();

  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    return await remoteDataSource.getProductDetail(productId);
  }

  @override
  Future<List<String>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return await remoteDataSource.getProductByCategory(category);
  }

  @override
  Future<List<Cart>> getUserCart(int idUser) async {
    return await remoteDataSource.getUserCart(idUser);
  }
}
