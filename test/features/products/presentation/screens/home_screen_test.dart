import 'package:ecommerce/features/products/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/errors/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:ecommerce/features/products/presentation/screens/home_screen.dart';

void main() {
  Widget createTestWidget(
    Widget child, {
    AsyncValue<Either<Failure, List<Product>>>? value,
  }) {
    return ProviderScope(child: MaterialApp(home: child));
  }

  testWidgets('Muestra loader cuando provider está en loading', (tester) async {
    await tester.pumpWidget(createTestWidget(const HomeScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Muestra mensaje de error cuando provider devuelve Failure', (
    tester,
  ) async {
    final failure = ServerFailure(404);

    await tester.pumpWidget(
      createTestWidget(const HomeScreen(), value: AsyncData(Left(failure))),
    );

    expect(find.textContaining(failure.message ?? ''), findsOneWidget);
  });

  testWidgets('El botón de carrito aparece en el AppBar', (tester) async {
    final mockProducts = [
      Product(id: 1, title: 'Zapatos', image: '', price: 50.0),
      Product(id: 2, title: 'Camisa', image: '', price: 30.0),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsListProvider.overrideWith((ref) async => Right(mockProducts)),
        ],
        child: MaterialApp(home: const HomeScreen()),
      ),
    );

    final cartButton = find.byIcon(Icons.shopping_bag_outlined);
    expect(cartButton, findsOneWidget);
  });
}
