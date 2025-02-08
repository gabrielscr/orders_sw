import 'package:orders_sw/src/core/exception/status_code.dart';

class ApiException implements Exception {
  const ApiException(
    this.message,
    this.statusCode,
  );

  const ApiException.general()
      : message = 'server-error',
        statusCode = StatusCode.e500;

  final String message;
  final int statusCode;

  bool get isServerError => statusCode == StatusCode.e500;
  bool get isUnauthorized => statusCode == StatusCode.e401;
}
