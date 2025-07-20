import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/login_response.dart';
import 'package:fake_store_get_request/models/sing_up_request.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';

import '../../../../core/errors/auth_errors.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/providers/auth_notifier.dart';

class AuthRepositoryImpl implements AuthRepository {


  AuthRepositoryImpl();

  @override
  Future<Either<AuthError, LoginResponse>> login(String email, String password) async {
 try {
      final response = await remoteDataSource.login(email, password);
      
      // Verifica si las credenciales son válidas según tu API
      if (response.token == null || response.token!.isEmpty) {
        return Left(InvalidCredentialsError());
      }
      
      return Right(response);
    } catch
   
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


class AuthRepositoryImpl implements AuthRepository {
  final FakeStoreService remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AuthError, LoginResponse>> login(
    String email, 
    String password,
  ) async {
    try {
      final response = await remoteDataSource.login(email, password);
      
      if (response.token.isEmpty) {
        return Left(InvalidCredentialsError());
      }
      
      return Right(response);
    } on DioException catch (e) {
      // Manejo de errores de Dio (si FakeStoreService usa Dio)
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkError());
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsError());
      } else if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 500) {
        return Left(ServerError());
      } else {
        return Left(UnknownAuthError());
      }
    } catch (e) {
      // Captura cualquier otro error inesperado
      return Left(UnknownAuthError());
    }
  }
}