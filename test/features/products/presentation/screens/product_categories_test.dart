import 'package:ecommerce/features/products/presentation/providers/products_by_category.dart';
import 'package:ecommerce/features/products/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/widgets/empty.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:ecommerce/features/products/presentation/screens/product_categories.dart';

Widget createTestWidget({
  required Widget child,
  String? selectedCategory,
  AsyncValue<List<Product>>? productsAsync,
  AsyncValue<List<String>>? categoriesAsync,
}) {
  return ProviderScope(
    overrides: [
      if (categoriesAsync != null)
        categoriesProvider.overrideWith((ref) async {
          // categoriesProvider es un FutureProvider<List<String>>
          return categoriesAsync.when(
            data: (data) => data,
            loading: () => Future.value([]),
            error: (err, _) => Future.error(err),
          );
        }),
      if (selectedCategory != null)
        selectedCategoryProvider.overrideWith((ref) => selectedCategory),
      if (productsAsync != null)
        productsByCategoryProvider.overrideWith((ref) {
          final useCase = ref.read(getProductsByCategoryUsecaseProvider);
          final notifier = ProductsByCategoryNotifier(useCase);
          notifier.state = productsAsync;
          return notifier;
        }),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
   

      group('ProductCategories widget tests', () {
         testWidgets('Muestra loading en categorías y productos', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const ProductCategories(),
          categoriesAsync: const AsyncLoading(),
          productsAsync: const AsyncLoading(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });
        // testWidgets('Renderiza chips de categorías y cambia selección', (
        //   tester,
        // ) async {
        //   await tester.pumpWidget(
        //     createTestWidget(
        //       child: const ProductCategories(),
        //       categoriesAsync: const AsyncData(['Electrónica', 'Ropa']),
        //       selectedCategory: 'Todas',
        //       productsAsync: const AsyncData([]),
        //     ),
        //   );

        //   await tester.pumpAndSettle();

        //   expect(find.text('Todas'), findsOneWidget);
        //   expect(find.text('Electrónica'), findsOneWidget);

        //   await tester.tap(find.text('Ropa'));
        //   await tester.pumpAndSettle();

        //   expect(find.text('Ropa'), findsWidgets);
        // });

        // testWidgets('Renderiza productos de la categoría', (tester) async {
        //   final mockProducts = [
        //     Product(id: 1, title: 'Zapatos', image: '', price: 50.0),
        //     Product(id: 2, title: 'Camisa', image: '', price: 30.0),
        //   ];

        //   await tester.pumpWidget(
        //     createTestWidget(
        //       child: const ProductCategories(),
        //       categoriesAsync: const AsyncData(['Zapatos', 'Ropa']),
        //       selectedCategory: 'Zapatos',
        //       productsAsync: AsyncData(mockProducts),
        //     ),
        //   );

        //   await tester.pumpAndSettle();

        //   expect(find.text('Zapatos'), findsOneWidget);
        //   expect(find.text('Camisa'), findsOneWidget);
        // });
      });
}
