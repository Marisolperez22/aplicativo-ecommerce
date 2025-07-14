import 'package:fake_store_get_request/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
}