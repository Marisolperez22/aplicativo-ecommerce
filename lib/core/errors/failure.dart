abstract class Failure {
  final String? title;
  final int? codeError;
  final String? message;

  const Failure({this.title, this.message, this.codeError});
}

///When the response status is different than 200
class ServerFailure extends Failure {
  const ServerFailure(this.statusCode) : super();

  final int statusCode;
}

class NetworkFailure extends Failure {
  ///When the app can't connect to the server
  const NetworkFailure();
}

class TimeOutFailure extends Failure {
  ///When the server is slow to respond
  const TimeOutFailure();
}

class AnotherFailure extends Failure {
  ///When an unknown exception occurs
  const AnotherFailure({super.message = '', super.codeError = 0});
}

class DataNull extends Failure {
  ///When the data is it Null
  const DataNull();
}

class AuthFailure extends Failure {
  ///When an unknown exception occurs
  const AuthFailure();
}

class BadRequest extends Failure {
  const BadRequest({super.title, super.message, super.codeError});
}
