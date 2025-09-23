import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
import 'package:injectable/injectable.dart';

abstract class IProductsDatasource {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<Cart> getUserCart(int idUser);
  Future<Product> getProductDetail(int productId);
  Future<List<Product>> getProductsByCategory(String category);
}

@Injectable(as: IProductsDatasource)
class ProductsDatasource implements IProductsDatasource {
  final FakeStoreService remoteDataSource;

  ProductsDatasource({required this.remoteDataSource});

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
    return await remoteDataSource.getProductsByCategory(category);
  }

  @override
  Future<Cart> getUserCart(int idUser) async {
    return await remoteDataSource.getUserCart(idUser);
  }
}
