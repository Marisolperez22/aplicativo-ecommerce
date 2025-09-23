import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FakeStoreService remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponse> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }
}

