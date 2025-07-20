abstract class AuthError {
  final String message;
  const AuthError(this.message);
}

class InvalidCredentialsError extends AuthError {
  const InvalidCredentialsError() : super('Credenciales inválidas');
}

class NetworkError extends AuthError {
  const NetworkError() : super('Error de conexión');
}

class ServerError extends AuthError {
  const ServerError() : super('Error del servidor');
}

class UnknownAuthError extends AuthError {
  const UnknownAuthError() : super('Error desconocido');
}