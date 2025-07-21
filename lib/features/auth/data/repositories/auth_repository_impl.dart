import 'package:fake_store_get_request/models/login_response.dart';
import 'package:fake_store_get_request/models/sing_up_request.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final remoteDataSource = FakeStoreService();

  AuthRepositoryImpl();

  @override
  Future<LoginResponse> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<void> signUp(SignupRequest request) async {
    try {
      return await remoteDataSource.signUp(request);
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }
}
