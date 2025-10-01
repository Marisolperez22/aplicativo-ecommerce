import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Screen', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Mostrar productos en Home', (tester) async {
      await login(tester);

      expect(find.text('Fake Store'), findsOneWidget);
      expect(find.textContaining('Los más vendidos'), findsOneWidget);
    });

    testWidgets('Navegar al carrito desde icono', (tester) async {
      await login(tester);

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Carrito'), findsOneWidget);
    });
  });
}
