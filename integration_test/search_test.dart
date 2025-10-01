import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search Screen', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Buscar productos por nombre', (tester) async {
      await login(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'shirt');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.textContaining('shirt', findRichText: true), findsWidgets);
    });

    testWidgets('Mostrar mensaje sin resultados', (tester) async {
      await login(tester);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'producto_inexistente');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('No encontramos resultados para:'), findsOneWidget);
    });
  });
}
