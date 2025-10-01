import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Categorías', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('UserName')), 'mor_2314');
      await tester.enterText(find.byKey(const Key('Password')).last, '83r5^_');
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Filtrar productos por categoría', (tester) async {
      await login(tester);

      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Categorías'), findsOneWidget);

      await tester.tap(find.textContaining('Electronics'));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
