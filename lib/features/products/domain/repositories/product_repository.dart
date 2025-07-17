import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<Product> getProductDetail(int productId);
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Cart>> getUserCart(int idUser);
}