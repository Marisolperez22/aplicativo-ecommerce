class BaseClientException implements Exception {
  BaseClientException({
    this.title,
    this.message,
    this.codeError,
    this.serverTime,
    this.stackTrace,
    this.statusCode,
    required this.url,
    required this.type,
  });
  final String url;
  final String type;
  final String? title;
  final int? codeError;
  final int? statusCode;
  final String? message;
  final DateTime? serverTime;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '''
      $type [
        url: $url
        status: $statusCode
        codeError: $codeError
        serverTime: $serverTime
        descriptionCodeError: $title
        ] : $message''';
  }
}
