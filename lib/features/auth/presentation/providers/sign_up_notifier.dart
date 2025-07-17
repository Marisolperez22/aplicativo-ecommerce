import 'package:fake_store_get_request/models/sing_up_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final signUpNotifierProvider = StateNotifierProvider<SignUpNotifier, SignUpState>((
  ref,
) {
  return 
  SignUpNotifier(ref.read(authRepositoryProvider));
});
class SignUpNotifier extends StateNotifier<SignUpState> {
  final AuthRepository _repository;

  SignUpNotifier(this._repository) : super(SignUpInitial());

  Future<void> signUp(SignupRequest request) async {
    state = SignUpLoading();
    try {
      await _repository.signUp(request);
      state = SignUpRegistered();
    } catch (e) {
      state = SignUpError(e.toString());
    }
  }
}

// Estados
abstract class SignUpState {}
class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpRegistered extends SignUpState {}
class SignUpError extends SignUpState {
  final String message;
  SignUpError(this.message);
}