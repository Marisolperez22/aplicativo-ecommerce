import 'package:flutter/material.dart';
import 'package:ecommerce/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Screen', () {
    testWidgets('Login exitoso redirige al Home', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsAny);

      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');

      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Fake Store'), findsOneWidget);
    });

    testWidgets('Mostrar error si los campos están vacíos', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Por favor ingrese un valor'), findsWidgets);
    });
  });
}
