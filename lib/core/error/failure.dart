abstract class Failure {
  final String? title;
  final int? codeError;
  final String? message;

  const Failure({this.title, this.message, this.codeError});
}
