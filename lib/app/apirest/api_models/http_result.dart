// Darwin Morocho
// ignore_for_file: public_member_api_docs, sort_constructors_first

class HttpResult<T> {
  final T? data;
  final int statusCode;
  final HttpError? error;

  HttpResult({
    required this.data,
    required this.statusCode,
    required this.error,
  });
}

class HttpError {
  final Object? exception;
  final StackTrace? stackTrace;
  final dynamic data;

  HttpError({
    required this.exception,
    required this.stackTrace,
    required this.data,
  });
}
