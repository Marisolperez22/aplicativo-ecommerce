import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../data/models/cart_item.dart';

final cartNotifierProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      // Incrementar cantidad si el producto ya existe
      state = [
        ...state..[index] = CartItem(
          product: product,
          quantity: state[index].quantity + 1,
        ),
      ];
    } else {
      // Añadir nuevo producto
      state = [...state, CartItem(product: product)];
    }
  }

  void decreaseQuantity(int productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (state[index].quantity > 1) {
        // Disminuir cantidad
        state = [
          ...state..[index] = CartItem(
            product: state[index].product,
            quantity: state[index].quantity - 1,
          ),
        ];
      } else {
        // Eliminar si la cantidad llega a 0
        removeProduct(productId);
      }
    }
  }

  void removeProduct(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }
}
extension CartItemCopyWith on CartItem {
  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}