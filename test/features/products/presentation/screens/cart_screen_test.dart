import 'package:ecommerce/features/products/data/models/cart_item.dart';
import 'package:ecommerce/features/products/presentation/providers/cart_notifier.dart';
import 'package:ecommerce/features/products/presentation/screens/cart_screen.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late List<CartItem> mockCart;

  setUp(() {
    mockCart = [
      CartItem(
        product: Product(
          id: 1,
          title: 'Zapatos',
          image: '',
          price: 50.0,
        ),
        quantity: 2,
      ),
      CartItem(
        product: Product(
          id: 2,
          title: 'Camisa',
          image: '',
          price: 30.0,
        ),
        quantity: 1,
      ),
    ];
  });

  Widget createTestWidget(Widget child, {List<CartItem>? items}) {
    return ProviderScope(
      overrides: [
        cartNotifierProvider.overrideWith((_) {
          final notifier = CartNotifier();
          notifier.state = items ?? mockCart;
          return notifier;
        }),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('Muestra el título del AppBar', (tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));

    expect(find.text('Carrito'), findsOneWidget);
  });

  testWidgets('Renderiza todos los ítems del carrito', (tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));

    expect(find.text('Zapatos'), findsOneWidget);
    expect(find.text('Camisa'), findsOneWidget);
  });

  testWidgets('Muestra subtotal y total correctos', (tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));

    // subtotal: (50*2 + 30*1) = 130
    expect(find.textContaining('130.00'), findsOneWidget);

    // total: subtotal + 25
    expect(find.textContaining('155.00'), findsOneWidget);
  });

  testWidgets('Incrementa cantidad al presionar botón de aumentar', (tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));

    final increaseButton = find.byIcon(Icons.add).first;
    await tester.tap(increaseButton);
    await tester.pump();

    // Ahora el subtotal debe reflejar el cambio (Zapatos: 3 * 50 = 150, +30 = 180)
    expect(find.textContaining('180.00'), findsOneWidget);
    expect(find.textContaining('205.00'), findsOneWidget);
  });

  testWidgets('Disminuye cantidad al presionar botón de disminuir', (tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));

    final decreaseButton = find.byIcon(Icons.remove).first;
    await tester.tap(decreaseButton);
    await tester.pump();

    // Ahora subtotal: (Zapatos: 1 * 50) + (Camisa: 30) = 80
    expect(find.textContaining('80.00'), findsOneWidget);
    expect(find.textContaining('105.00'), findsOneWidget);
  });

  testWidgets('Elimina producto si cantidad llega a 0', (tester) async {
    final oneItemCart = [
      CartItem(
        product: Product(
          id: 3,
          title: 'Gorra',
          image: 'assets/placeholder.png',
          price: 20.0,
        ),
        quantity: 1,
      ),
    ];

    await tester.pumpWidget(createTestWidget(const CartScreen(), items: oneItemCart));

    expect(find.text('Gorra'), findsOneWidget);

    final decreaseButton = find.byIcon(Icons.remove).first;
    await tester.tap(decreaseButton);
    await tester.pump();

    // Ya no debe aparecer "Gorra" en el carrito
    expect(find.text('Gorra'), findsNothing);
  });

}
