import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: FakeStoreService(),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final response = await _authRepository.login(email, password);

      state = AuthAuthenticated(response, '');
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthInitial();
  }
}

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final LoginResponse token;
  final String userName;
  AuthAuthenticated(this.token, this.userName);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
