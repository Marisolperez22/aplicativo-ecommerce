import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';

import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final remoteDataSource = FakeStoreService();

  ProductRepositoryImpl();

  @override
  Future<List<Product>> getProducts() async {
    try {
      return await remoteDataSource.getProducts();
    } catch (e) {
      throw Exception('Loading products failed: $e');
    }
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    try {
      return await remoteDataSource.getProductDetail(productId);
    } catch (e) {
      throw Exception('Loading product details failed: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Error loading categories $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await remoteDataSource.getProductByCategory(category);
    } catch (e) {
      throw Exception('Loading products by category failed: $e');
    }
  }

    @override
  Future<List<Cart>> getUserCart(int idUser) async {
    try {
      return await remoteDataSource.getUserCart(idUser);
    } catch (e) {
      throw Exception('Error getting user cart: $e');
    }
  }

  
}
