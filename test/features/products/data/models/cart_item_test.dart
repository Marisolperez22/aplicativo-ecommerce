import 'package:ecommerce/features/products/data/models/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/data/models/product.dart';

void main() {
  group('CartItem', () {
    test('Debería inicializar con cantidad por defecto = 1', () {
      final product = Product(id: 1, title: 'Test product', price: 10.0);
      final cartItem = CartItem(product: product);

      expect(cartItem.quantity, 1);
      expect(cartItem.totalPrice, 10.0);
    });

    test('Debería calcular totalPrice con cantidad > 1', () {
      final product = Product(id: 2, title: 'Laptop', price: 1000.0);
      final cartItem = CartItem(product: product, quantity: 3);

      expect(cartItem.totalPrice, 3000.0);
    });

    test('Debería retornar 0 si product.price es null', () {
      final product = Product(id: 3, title: 'Item sin precio', price: null);
      final cartItem = CartItem(product: product, quantity: 5);

      expect(cartItem.totalPrice, 0.0);
    });

    test('Se puede modificar la cantidad después de crear el objeto', () {
      final product = Product(id: 4, title: 'Teclado', price: 50.0);
      final cartItem = CartItem(product: product);

      cartItem.quantity = 4;

      expect(cartItem.quantity, 4);
      expect(cartItem.totalPrice, 200.0);
    });
  });
}
