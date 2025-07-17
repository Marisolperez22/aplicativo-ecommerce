import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/login_response.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<Either<Failure, LoginResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final LoginResponse login = await remoteDataSource.login(email, password);
      return Right(login);
    } catch (e) {
      return Left();
    }
  }
}
