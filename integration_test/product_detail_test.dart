import 'package:flutter/material.dart';
import 'package:ecommerce/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Product Detail Screen', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Abrir detalle desde Home y añadir al carrito', (tester) async {
      await login(tester);

      await tester.tap(find.text('Comprar ahora'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Detalle del producto'), findsOneWidget);

      final addButton = find.textContaining('Añadir');
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      }
    });
  });
}
