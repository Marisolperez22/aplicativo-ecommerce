import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([FakeStoreService])
void main() {
  late MockFakeStoreService mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockFakeStoreService();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

 test('Debería retornar LoginResponse cuando login es exitoso', () async {
    // Arrange
    const email = "test@email.com";
    const password = "123456";
    final loginResponse = LoginResponse(token: "fake_token");

    when(mockRemoteDataSource.login(email, password))
        .thenAnswer((_) async => loginResponse);

    // Act
    final result = await repository.login(email, password);

    // Assert
    expect(result.token, "fake_token");
    verify(mockRemoteDataSource.login(email, password)).called(1);
  });
}
