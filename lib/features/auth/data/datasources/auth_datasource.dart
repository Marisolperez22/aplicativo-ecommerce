import 'package:fake_store_get_request/fake_store_get_request.dart';
import 'package:fake_store_get_request/models/login_response.dart';

class AuthDatasource {
  final FakeStoreService _service;

  AuthDatasource(this._service);

  Future<LoginResponse> login(String email, String password) async {
    return await _service.login(email, password);
  }
}
