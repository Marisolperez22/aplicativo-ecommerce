import 'package:flutter/material.dart';
import 'package:ecommerce/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🔐 Login Screen', () {
    testWidgets('Login exitoso redirige al Home', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Pantalla Login
      expect(find.text('Login'), findsAny);

      // Completar formulario
      await tester.enterText(find.byType(TextFormField).first, 'user');
      await tester.enterText(find.byType(TextFormField).last, '1234');

      // Tap en botón Login
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle();

      // Validar navegación al Home
      expect(find.text('Fake Store'), findsOneWidget);
    });

    testWidgets('Mostrar error si los campos están vacíos', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap sin llenar campos
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle();

      // Debe mostrar mensajes de error
      expect(find.textContaining('obligatorio'), findsWidgets);
    });
  });
}
