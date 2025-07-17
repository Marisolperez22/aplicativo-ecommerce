import 'package:fake_store_get_request/models/login_response.dart';
import 'package:fake_store_get_request/models/sing_up_request.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> signUp(SignupRequest request);

}