import 'package:fake_store_get_request/models/login_response.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
      final remoteDataSource = FakeStoreService();


  AuthRepositoryImpl();

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}