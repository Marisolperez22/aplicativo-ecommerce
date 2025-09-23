import 'package:ecommerce/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ecommerce/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
        authNotifierProvider.overrideWith((ref) => AuthNotifier(mockRepository)),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Renderiza campos de login y botones', (tester) async {
    await tester.pumpWidget(createTestWidget(const LoginScreen()));

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Login'), findsAny);
    expect(find.text('Registrarse'), findsOneWidget);
  });

  testWidgets('Muestra mensaje de error cuando el estado es AuthError', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith((ref) => AuthNotifier(mockRepository)..state = AuthError("Credenciales inválidas")),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text("Credenciales inválidas"), findsOneWidget);
  });

  testWidgets('Valida formulario vacío', (tester) async {
    await tester.pumpWidget(createTestWidget(const LoginScreen()));

    await tester.tap(find.byKey(Key('LoginButton')));
    await tester.pump();

    // Validador de Utils debería mostrar error
    expect(find.textContaining("Por favor ingrese un valor"), findsWidgets);
  });
}
