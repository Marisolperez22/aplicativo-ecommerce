import 'package:fake_store_get_request/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => (product.price ?? 0) * quantity;
}