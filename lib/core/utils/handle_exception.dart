// import 'package:either_dart/either.dart';

// import '../error/failure.dart';

// Either<Failure, T> handleException<T>(dynamic e) {
//   if (e is BaseClientException) {
//     log(e.toString());
//     if (e.type == 'SocketException') {
//       return const Left(NetworkFailure());
//     }
//     if (e.type == 'TimeoutException') {
//       return const Left(TimeOutFailure());
//     }
//     if (e.type == 'UnAuthorization') {
//       return const Left(AuthFailure());
//     }
//     if (e.type == 'BadRequest') {
//       return Left(
//         BadRequest(
//           title: e.title,
//           message: e.message,
//           codeError: e.codeError,
//         ),
//       );
//     }
//     return const Left(AnotherFailure());
//   } else {
//     log(e.toString());
//     return const Left(AnotherFailure());
//   }
// }
