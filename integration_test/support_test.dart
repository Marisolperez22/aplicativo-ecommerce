import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Soporte y Contacto', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Ver información de soporte y FAQs', (tester) async {
      await login(tester);

      await tester.tap(find.byIcon(Icons.help_outline_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Soporte y Contacto'), findsOneWidget);
      expect(find.text('Preguntas frecuentes'), findsOneWidget);
      expect(find.textContaining('¿Cómo realizo un pedido?'), findsOneWidget);
    });
  });
}
