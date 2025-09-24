import 'package:ecommerce/features/products/presentation/providers/cart_notifier.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late Product product;

  setUp(() {
    container = ProviderContainer();
    product = Product(id: 1, description: 'Test Product', price: 10.0);
  });

  tearDown(() {
    container.dispose();
  });

  test('Estado inicial debe ser lista vacía', () {
    final state = container.read(cartNotifierProvider);
    expect(state, isEmpty);
  });

  test('addProduct agrega un producto nuevo', () {
    final notifier = container.read(cartNotifierProvider.notifier);
    notifier.addProduct(product);

    final state = container.read(cartNotifierProvider);
    expect(state.length, 1);
    expect(state.first.product, equals(product));
    expect(state.first.quantity, 1);
  });

  test('addProduct incrementa cantidad si producto ya existe', () {
    final notifier = container.read(cartNotifierProvider.notifier);
    notifier.addProduct(product);
    notifier.addProduct(product);

    final state = container.read(cartNotifierProvider);
    expect(state.length, 1); // no se duplica
    expect(state.first.quantity, 2);
  });

  test('decreaseQuantity reduce cantidad cuando es > 1', () {
    final notifier = container.read(cartNotifierProvider.notifier);
    notifier.addProduct(product);
    notifier.addProduct(product); // cantidad = 2
    notifier.decreaseQuantity(product.id);

    final state = container.read(cartNotifierProvider);
    expect(state.first.quantity, 1);
  });

  test('decreaseQuantity elimina producto si cantidad = 1', () {
    final notifier = container.read(cartNotifierProvider.notifier);
    notifier.addProduct(product);
    notifier.decreaseQuantity(product.id);

    final state = container.read(cartNotifierProvider);
    expect(state, isEmpty);
  });

  test('removeProduct elimina el producto del carrito', () {
    final notifier = container.read(cartNotifierProvider.notifier);
    notifier.addProduct(product);
    notifier.removeProduct(product.id);

    final state = container.read(cartNotifierProvider);
    expect(state, isEmpty);
  });
}
