import 'package:fake_store_get_request/fake_store_get_request.dart';
import 'package:fake_store_get_request/models/login_response.dart';

abstract class IAuthDatasources {
  Future<LoginResponse> login({
    required String userName,
    required String password,
  });
}

class AuthDatasources implements IAuthDatasources {
  final remoteDataSource = FakeStoreService();

  @override
  Future<LoginResponse> login({
    required String userName,
    required String password,
  }) async {
    return await remoteDataSource.login(userName, password);
  }
}
