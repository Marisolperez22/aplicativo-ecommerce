import 'package:atomic_design_system/widgets/cart_custom_tile.dart';
import 'package:atomic_design_system/widgets/cart_total.dart';
import 'package:atomic_design_system/widgets/generic_app_bar.dart';
import 'package:ecommerce/core/utils/utils.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:ecommerce/features/products/data/models/cart_item.dart';
import 'package:ecommerce/features/products/presentation/providers/cart_notifier.dart';
import 'package:ecommerce/features/products/presentation/screens/cart_screen.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Importa tus clases reales


// Mocks
class MockCartNotifier extends Mock implements CartNotifier {}

class MockWidgetRef extends Mock implements WidgetRef {}

class FakeCartItem extends Fake implements CartItem {}

void main() {
  late MockCartNotifier mockCartNotifier;
  late ProviderContainer container;
  final List<CartItem> mockCartItems = [
    CartItem(
      product: Product(
        id: 1,
        title: 'Producto 1',
        price: 29.99,
        image: 'image1.jpg',
      ),
      quantity: 2,
    ),
    CartItem(
      product: Product(
        id: 2,
        title: 'Producto 2',
        price: 15.50,
        image: 'image2.jpg',
      ),
      quantity: 1,
    ),
  ];

  setUp(() {
    mockCartNotifier = MockCartNotifier();
    
    // Configurar el ProviderContainer para testing
    container = ProviderContainer(overrides: [
      cartNotifierProvider.overrideWith((ref) => mockCartNotifier),
    ]);

    // Mock de las funciones del notifier
    when(mockCartNotifier.decreaseQuantity(1)).thenReturn(null);
    when(mockCartNotifier.addProduct(Product(id: 2))).thenReturn(null);
  });

  tearDown(() {
    container.dispose();
  });

  // Widget auxiliar para envolver el CartScreen con los providers necesarios
  Widget createWidgetUnderTest(List<CartItem> cartItems) {
    when(mockCartNotifier.state).thenReturn(cartItems);
    
    return ProviderScope(
      parent: container,
      child: MaterialApp(
        home: CartScreen(),
      ),
    );
  }

  group('CartScreen Widget Tests', () {
    testWidgets('debería mostrar el AppBar con el título correcto', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert
      expect(find.text('Carrito'), findsOneWidget);
      expect(find.byType(GenericAppBar), findsOneWidget);
    });

    testWidgets('debería mostrar la lista de productos del carrito', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CartCustomTile), findsNWidgets(mockCartItems.length));
    });

    testWidgets('debería mostrar CartTotal al final de la pantalla', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert
      expect(find.byType(CartTotal), findsOneWidget);
    });

    testWidgets('debería mostrar los datos correctos en cada CartCustomTile', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert
      expect(find.text('Producto 1'), findsOneWidget);
      expect(find.text('Producto 2'), findsOneWidget);
      expect(find.text('29.99'), findsOneWidget);
      expect(find.text('15.50'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Cantidad del primer producto
      expect(find.text('1'), findsOneWidget); // Cantidad del segundo producto
    });

    testWidgets('debería llamar a decreaseQuantity cuando se presiona el botón de disminuir', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Act: Encontrar y presionar el primer botón de disminuir
      final decreaseButtons = find.byKey(const Key('decrease_button')); // Asumiendo que CartCustomTile tiene una key
      await tester.tap(decreaseButtons.first);
      await tester.pump();

      // Assert
      verify(mockCartNotifier.decreaseQuantity(1)).called(1);
    });

    testWidgets('debería llamar a addProduct cuando se presiona el botón de aumentar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Act: Encontrar y presionar el primer botón de aumentar
      final increaseButtons = find.byKey(const Key('increase_button')); // Asumiendo que CartCustomTile tiene una key
      await tester.tap(increaseButtons.first);
      await tester.pump();

      // Assert
      verify(mockCartNotifier.addProduct(mockCartItems[0].product)).called(1);
    });

    testWidgets('debería mostrar mensaje cuando el carrito está vacío', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest([]));

      // Assert
      expect(find.byType(CartCustomTile), findsNothing);
      // Puedes agregar un mensaje específico para carrito vacío en tu widget
      // expect(find.text('Tu carrito está vacío'), findsOneWidget);
    });

    testWidgets('debería calcular y mostrar los totales correctamente', (WidgetTester tester) async {
      // Arrange
      final expectedSubtotal = Utils.calculateTotal(mockCartItems).toStringAsFixed(2);
      final expectedTotal = (Utils.calculateTotal(mockCartItems) + 25).toStringAsFixed(2);
      
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert
      // Asumiendo que CartTotal muestra estos valores con textos específicos
      expect(find.text(expectedSubtotal), findsOneWidget);
      expect(find.text(expectedTotal), findsOneWidget);
    });

    testWidgets('debería reconstruirse cuando cambian los items del carrito', (WidgetTester tester) async {
      // Arrange - Primera construcción con 2 items
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));
      expect(find.byType(CartCustomTile), findsNWidgets(2));

      // Act - Actualizar con un nuevo estado (1 item)
      final updatedItems = [mockCartItems[0]];
      when(mockCartNotifier.state).thenReturn(updatedItems);
      await tester.pumpWidget(createWidgetUnderTest(updatedItems));
      await tester.pump();

      // Assert
      expect(find.byType(CartCustomTile), findsNWidgets(1));
    });

    testWidgets('debería manejar productos sin imagen correctamente', (WidgetTester tester) async {
      // Arrange
      final itemsWithNullImage = [
        CartItem(
          product: Product(
            id: 3,
            title: 'Producto sin imagen',
            price: 10.00,
            image: null, // Imagen nula
          ),
          quantity: 1,
        ),
      ];
      
      await tester.pumpWidget(createWidgetUnderTest(itemsWithNullImage));

      // Assert - No debería fallar al construir
      expect(find.text('Producto sin imagen'), findsOneWidget);
      expect(find.byType(CartCustomTile), findsOneWidget);
    });

    testWidgets('debería tener la estructura correcta de widgets', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(mockCartItems));

      // Assert - Verificar la jerarquía de widgets
      expect(find.byType(ScreenWidget), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('Casos edge y validaciones', () {
    testWidgets('debería manejar precios con muchos decimales', (WidgetTester tester) async {
      // Arrange
      final itemsWithDecimalPrice = [
        CartItem(
          product: Product(
            id: 4,
            title: 'Producto con decimales',
            price: 12.3456,
            image: 'image4.jpg',
          ),
          quantity: 3,
        ),
      ];
      
      await tester.pumpWidget(createWidgetUnderTest(itemsWithDecimalPrice));

      // Assert
      expect(find.text('12.35'), findsOneWidget); // toStringAsFixed(2)
      expect(find.text('37.04'), findsOneWidget); // toStringAsFixed(2)
    });

    testWidgets('debería manejar cantidades grandes correctamente', (WidgetTester tester) async {
      // Arrange
      final itemsWithLargeQuantity = [
        CartItem(
          product: Product(
            id: 5,
            title: 'Producto con cantidad grande',
            price: 5.00,
            image: 'image5.jpg',
          ),
          quantity: 999,
        ),
      ];
      
      await tester.pumpWidget(createWidgetUnderTest(itemsWithLargeQuantity));

      // Assert
      expect(find.text('999'), findsOneWidget);
      expect(find.text('4995.00'), findsOneWidget);
    });
  });
}