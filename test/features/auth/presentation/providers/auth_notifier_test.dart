import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_notifier_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
        authNotifierProvider.overrideWith((ref) => AuthNotifier(mockRepository)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Login exitoso debería emitir AuthAuthenticated', () async {
    // Arrange
    const email = "test@email.com";
    const password = "123456";
    final loginResponse = LoginResponse(token: "fake_token");

    when(mockRepository.login(email, password))
        .thenAnswer((_) async => loginResponse);

    final notifier = container.read(authNotifierProvider.notifier);

    // Act
    await notifier.login(email, password);

    // Assert
    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).token.token, "fake_token");
    verify(mockRepository.login(email, password)).called(1);
  });

  test('Login fallido debería emitir AuthError', () async {
    // Arrange
    const email = "fail@email.com";
    const password = "wrong";
    when(mockRepository.login(email, password))
        .thenThrow(Exception("Credenciales inválidas"));

    final notifier = container.read(authNotifierProvider.notifier);

    // Act
    await notifier.login(email, password);

    // Assert
    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, contains("Credenciales inválidas"));
  });

  test('Logout debería volver a AuthInitial', () async {
    final notifier = container.read(authNotifierProvider.notifier);

    // Simular estado autenticado
    notifier.state = AuthAuthenticated(LoginResponse(token: "fake_token"), "user");

    // Act
    await notifier.logout();

    // Assert
    expect(notifier.state, isA<AuthInitial>());
  });
}
