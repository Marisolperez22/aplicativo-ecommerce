import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Carrito', () {
    Future<void> loginAndAddProduct(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Comprar ahora'));
      await tester.pumpAndSettle();
      final addButton = find.textContaining('Añadir');
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        await tester.pump();
      }
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    testWidgets('Mostrar productos añadidos', (tester) async {
      await loginAndAddProduct(tester);

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Carrito'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
